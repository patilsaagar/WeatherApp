//
//  WeatherService.swift
//  WeatherApp
//
//  Created by Sagar Patil on 28/11/2021.
//

import CoreLocation

protocol WeatherServiceProtocol {
    func geocodeAddressString(from cityName: String, completion: @escaping CLGeocodeCompletionHandler)
    func getCityWeatherData(cityName: String, cityLatitude: Double, longitude: Double, completion: @escaping (Result<Forcast, NetworkManager.FetchError>) -> Void)
    var networkController: NetworkControllerProtocol? { get set }
}

final class WeatherService: WeatherServiceProtocol {
    var networkController: NetworkControllerProtocol?
    func geocodeAddressString(from cityName: String, completion: @escaping CLGeocodeCompletionHandler) {
        CLGeocoder().geocodeAddressString(cityName) { placemark, error in
            completion(placemark, error)
        }
    }
    
    func getCityWeatherData(cityName: String, cityLatitude: Double, longitude: Double, completion: @escaping (Result<Forcast, NetworkManager.FetchError>) -> Void) {
        let baseURL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(cityLatitude)&lon=\(longitude)&exclude=hourly,minutely,current,alert&appid=63d13625d03f61d44d76f161f7dbb7c2&units=metric"
        
        self.networkController?.fetch(baseUrl: baseURL, completion: { expectedData, expectedResponse, error in
            var result: Result<Data?, Error>
            
            if error != nil {
                result = .failure(NetworkManager.FetchError.network(error!))
            }
            
            if let _ = expectedResponse as? HTTPURLResponse  {
                result = .failure(NetworkManager.FetchError.missingResponse)
            }
            
            //            if (200...299).contains(expectedResponse.)  {
            //                result = .failure(NetworkController.FetchError.unexpectedResonse(expectedResponse.statusCode))
            //            }
            
            if let finalData = expectedData  {
                result = .success(finalData)
            } else {
                result = .failure(NetworkManager.FetchError.invalidData)
            }
            
            switch result {
            case .success(let responseData):
                do {
                    let jsonDecoder = JSONDecoder()
                    if let data = responseData {
                        let weatherDetails = try jsonDecoder.decode(Forcast.self, from: data)
                        completion(.success(weatherDetails))
                    } else {
                        completion(.failure(NetworkManager.FetchError.invalidData))
                    }
                } catch {
                    completion(.failure(.invalidJSON(error)))
                }
            case .failure(_):
                completion(.failure(NetworkManager.FetchError.noResponse))
            }
        })
    }
}
