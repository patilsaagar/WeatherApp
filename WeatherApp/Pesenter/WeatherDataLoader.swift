//
//  WeatherDataLoader.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import Foundation

protocol WeatherDataProtocol: AnyObject {
    var weatherView: WeatherViewProtocol? { get set }
    var weatherDetails: Forcast? { get set }
    func getCityWeatherData(cityName: String)
    func attachView(view: WeatherViewProtocol)
}

class WeatherDataLoader: WeatherDataProtocol {
    weak var weatherView: WeatherViewProtocol?
    var weatherDetails: Forcast?
    
    let url = "https://api.openweathermap.org/data/2.5/onecall?lat=53.423051&lon=-2.317955&exclude=hourly,minutely,current,alert&appid=63d13625d03f61d44d76f161f7dbb7c2"

    func attachView(view: WeatherViewProtocol) {
        self.weatherView = view
    }

    func getCityWeatherData(cityName: String) {
        let network = NetworkController(baseURL: self.url)
        network.fetchWeatherData(anObject: URLSession.shared) { weatherDetails in
            switch weatherDetails {
            case .success(let weatherDetails):
                    self.weatherView?.createWeatherData(details: weatherDetails, cityName: cityName)
                    self.weatherDetails = weatherDetails
            case .failure:
                break
            }
        }
    }
}
