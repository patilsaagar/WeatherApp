//
//  WeatherDataLoader.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import Foundation
import CoreLocation

protocol WeatherDataProtocol: AnyObject {
    var weatherView: WeatherViewProtocol? { get set }
    var weatherDetails: [Daily]? { get set }
    func getCityWeatherData(cityName: String, cityLatitude: Double, longitude: Double)
    func attachView(view: WeatherViewProtocol)
    func getCityCoordinate(from cityName: String)
}

class WeatherDataLoader: WeatherDataProtocol {
    weak var weatherView: WeatherViewProtocol?
    var weatherDetails: [Daily]?
    
    func attachView(view: WeatherViewProtocol) {
        self.weatherView = view
    }

    func getCityWeatherData(cityName: String, cityLatitude: Double, longitude: Double) {
        let network = NetworkController(baseURL: "https://api.openweathermap.org/data/2.5/onecall?lat=\(cityLatitude)&lon=\(longitude)&exclude=hourly,minutely,current,alert&appid=63d13625d03f61d44d76f161f7dbb7c2&units=metric")
        
        network.fetchWeatherData(anObject: URLSession.shared) { weatherDetails in
            switch weatherDetails {
            case .success(let weatherDetails):
                self.weatherView?.setupWeatherUI(details: weatherDetails.daily, cityName: cityName)
                self.weatherDetails = weatherDetails.daily
            case .failure:
                break
            }
        }
    }
    
    func getCityCoordinate(from cityName: String) {
        CLGeocoder().geocodeAddressString(cityName) { placemark, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let latitude = placemark?.first?.location?.coordinate.latitude,
               let longitude = placemark?.first?.location?.coordinate.longitude {
                self.getCityWeatherData(cityName: cityName, cityLatitude: latitude, longitude: longitude)
            }
        }

    }
}
