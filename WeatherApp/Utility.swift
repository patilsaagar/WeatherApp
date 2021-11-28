//
//  Utility.swift
//  WeatherApp
//
//  Created by Sagar Patil on 28/11/2021.
//

struct Utility {
    var initialValue: Int

    func convertTemperatureToDegreeCelsius(value: Double) -> Double {
        let celsius = value - 273.5
        if initialValue == 0 {
            return celsius
        }  else {
            return celsius * 9 / 5 + 32
        }
    }
}
