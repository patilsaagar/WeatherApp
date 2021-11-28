//
//  WeatherDetailsTableViewCell.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import UIKit

class WeatherDetailsTableViewCell: UITableViewCell {
    static let cellIdentifier = "WeatherDetailsTableViewCell"

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minimumTemperature: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var maximumTemperature: UILabel!
    
    @IBOutlet weak var iConDescriptionLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: WeatherDetailsTableViewCell.cellIdentifier, bundle: nil)
    }
}

extension WeatherDetailsTableViewCell: Covertable {
    /// Method to configure table custom cell
    /// - Parameters:
    ///   - weatherData: Weather data to setup cell values
    ///   - index: index reference for tableview
    func configureCell(with weatherData: [Daily], index: Int) {
        self.dayLabel.text = self.convertDate(date: weatherData[index].dt)
        self.minimumTemperature.text =  "\(Int(weatherData[index].temp.min))℃"
        self.maximumTemperature.text = "\(Int(weatherData[index].temp.max))℃"
        
        let iconName = weatherData[index].weather[0].icon
        let iconURL = "https://openweathermap.org/img/wn/\(iconName)@2x.png"
        
        guard let url = URL(string: iconURL) else { return }
        self.weatherIconImageView.loadImageFrom(url: url)
        
        self.iConDescriptionLabel.text = weatherData[index].weather[0].description.capitalized
    }
}
