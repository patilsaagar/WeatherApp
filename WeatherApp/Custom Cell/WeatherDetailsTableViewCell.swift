//
//  WeatherDetailsTableViewCell.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import UIKit

class WeatherDetailsTableViewCell: UITableViewCell, Formattable {    
    static let cellIdentifier = "WeatherDetailsTableViewCell"

    @IBOutlet weak var dayLabel: UILabel!
    @IBOutlet weak var minimumTemperature: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var maximumTemperature: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: WeatherDetailsTableViewCell.cellIdentifier, bundle: nil)
    }
    
    func configureCell(with weatherData: Forcast, index: Int) {
        self.dayLabel.text = self.convertDate(date: weatherData.daily[index].dt)
        self.minimumTemperature.text =  (convertTemperatureToDegreeCelsius(value: weatherData.daily[index].temp.min))
        self.maximumTemperature.text = (convertTemperatureToDegreeCelsius(value: weatherData.daily[index].temp.max))
       // self.weatherIconImageView.image = UIImage() weatherData.daily[indexPath.row].weather[indexPath.row].icon
    }
    
    private func convertDate(date: Date?) -> String{
        guard let date = date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        
        return dateFormatter.string(from: date)
    }
}
