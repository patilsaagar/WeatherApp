//
//  Forcast.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import Foundation

struct Forcast: Codable {
    let daily: [Daily]
}

struct Daily: Codable {
    let dt: Date
    let temp: Temp
    let humidity: Int
    let weather: [Weather]
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
    let description: String
    let icon: String
}


