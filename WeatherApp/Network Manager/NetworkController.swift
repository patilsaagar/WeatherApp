//
//  NetworkController.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import Foundation

protocol NetworkControllerDelegate {
    func fetch(baseUrl: String, completion: @escaping (Result<Data, Error>) -> Void)
}

class NetworkController {
    private let baseURL: String
    
    init(baseURL: String) {
        self.baseURL = baseURL
    }
    
    enum FetchError : Error {
        case network(Error)
        case noResponse
        case invalidData
        case invalidJSON(Error)
        case missingResponse
        case unexpectedResonse(Int)
    }
    
    func fetchWeatherData(anObject: NetworkControllerDelegate, completion: @escaping (Result<Forcast, FetchError>) -> Void) {
        anObject.fetch(baseUrl: self.baseURL) { result in
            switch result {
            case .success(let responseData):
                do {
                    let jsonDecoder = JSONDecoder()
                    let weatherDetails = try jsonDecoder.decode(Forcast.self, from: responseData)
                    completion(.success(weatherDetails))
                } catch {
                    completion(.failure(.invalidJSON(error)))
                }
            case .failure(let errorData):
                completion(.failure(errorData as! FetchError))
            }
        }
    }
}

extension URLSession: NetworkControllerDelegate {
    func fetch(baseUrl: String, completion: @escaping (Result<Data, Error>) -> Void) {
        
        guard let url = URL(string: baseUrl) else{
                return
            }
        
        let task = URLSession.shared.dataTask(with: url) { expectedData, expectedResponse, error in
            guard error == nil else {
                completion(.failure(NetworkController.FetchError.network(error!)))
                return
            }
            
            guard let response = expectedResponse as? HTTPURLResponse else {
                completion(.failure(NetworkController.FetchError.missingResponse))
                return
            }
            
            guard (200...299).contains(response.statusCode) else {
                completion(.failure(NetworkController.FetchError.unexpectedResonse(response.statusCode)))
                return
            }
            
            guard let finalData = expectedData else {
                completion(.failure(NetworkController.FetchError.invalidData))
                return
            }
            
            completion(.success(finalData))
        }
        task.resume()
    }
}
