//
//  WeatherDataLoader.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import Foundation

protocol WeatherDataProtocol: AnyObject {
    var weatherView: WeatherViewProtocol? { get set }
    var weatherDetails: [Daily]? { get set }
    var service: WeatherServiceProtocol? { get set }
    func getCityWeatherData(cityName: String, cityLatitude: Double, longitude: Double)
    func attachView(view: WeatherViewProtocol)
    func getCityCoordinate(from cityName: String)
}

class WeatherDataPresenter: WeatherDataProtocol {
    weak var weatherView: WeatherViewProtocol?
    var weatherDetails: [Daily]?
    var service: WeatherServiceProtocol?
    
    func attachView(view: WeatherViewProtocol) {
        self.weatherView = view
    }
    
    func getCityWeatherData(cityName: String, cityLatitude: Double, longitude: Double) {
        service?.getCityWeatherData(cityName: cityName, latitude: cityLatitude, longitude: longitude, completion: { result in
            switch result {
            case .success(let weatherDetails):
                self.weatherView?.setupWeatherUI(details: weatherDetails.daily, cityName: cityName)
                self.weatherDetails = weatherDetails.daily
            case .failure:
                break
            }        })
    }
    
    func getCityCoordinate(from cityName: String) {
        service?.geocodeAddressString(from: cityName, completion: { placemark, error in
            if let error = error {
                print(error.localizedDescription)
            }
            
            if let latitude = placemark?.first?.location?.coordinate.latitude,
               let longitude = placemark?.first?.location?.coordinate.longitude {
                self.getCityWeatherData(cityName: cityName, cityLatitude: latitude, longitude: longitude)
            } })
    }
}
