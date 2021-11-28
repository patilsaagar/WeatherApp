//
//  NetworkController.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import Foundation

protocol NetworkControllerProtocol {
    func fetch(baseUrl: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void)
}

class NetworkManager: NetworkControllerProtocol {        
    enum FetchError : Error {
        case network(Error)
        case noResponse
        case invalidData
        case invalidJSON(Error)
        case missingResponse
        case unexpectedResonse(Int)
    }
        
    func fetch(baseUrl: String, completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        
        guard let url = URL(string: baseUrl) else{
                return
            }
        
        let task = URLSession.shared.dataTask(with: url) { expectedData, expectedResponse, error in
            completion(expectedData, expectedResponse, error)
        }
        task.resume()
    }
}
