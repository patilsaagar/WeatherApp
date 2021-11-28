//
//  Utility.swift
//  WeatherApp
//
//  Created by Sagar Patil on 28/11/2021.
//

import Foundation

protocol Covertable {
    func convertDate(date: Date?) -> String
}


extension Covertable {
    func convertDate(date: Date?) -> String {
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        return dateFormatter.string(from: date)
    }
}
