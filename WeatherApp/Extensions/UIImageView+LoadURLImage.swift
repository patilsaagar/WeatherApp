//
//  UIImageView+LoadURLImage.swift
//  WeatherApp
//
//  Created by Sagar Patil on 28/11/2021.
//

import UIKit

extension UIImageView {
    func loadImageFrom(url: URL){
        DispatchQueue.global().async { [weak self] in
            if let data = try? Data(contentsOf: url) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
