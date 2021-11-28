//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import UIKit
import CoreLocation

protocol WeatherViewProtocol: AnyObject {
    var weatherData: WeatherDataProtocol? { get set }
    func setupWeatherUI(details: [Daily], cityName: String)
}

class WeatherViewController: UIViewController, WeatherViewProtocol {
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var temperatureDetailsStackView: UIStackView!
    @IBOutlet weak var dailyWeatherDataTableView: UITableView! {
        didSet {
            dailyWeatherDataTableView.register(WeatherDetailsTableViewCell.nib(), forCellReuseIdentifier: WeatherDetailsTableViewCell.cellIdentifier)
            dailyWeatherDataTableView.dataSource = self
            dailyWeatherDataTableView.delegate = self
            dailyWeatherDataTableView.backgroundColor  = .clear
        }
    }

    private var weatherDetails: [Daily]?
    var weatherData: WeatherDataProtocol?
    
    // MARK: View Life cycle method
    override func viewDidLoad() {
        super.viewDidLoad()
        let networkController = NetworkManager()
        let service = WeatherService()
        service.networkController = networkController
        let weatherData = WeatherDataPresenter()
        weatherData.service = service
        self.weatherData = weatherData
        self.weatherData?.attachView(view: self)
    }
    
    
    /// Method which will set the UI with weather details
    /// - Parameters:
    ///   - details: Weather details returnd from API
    ///   - cityName: City name for which weather will display
    func setupWeatherUI(details: [Daily], cityName: String) {
        self.weatherDetails = details
        DispatchQueue.main.async {
            self.cityNameLabel.text = cityName.capitalized
            
            if let minimumTemperature = self.weatherDetails?.first?.temp.min,
               let maximumTemperature = self.weatherDetails?.first?.temp.max {
                let lowTemperature = minimumTemperature
                let highTemperature = maximumTemperature
                
                self.lowTemperatureLabel.text = "L: " + "\(Int(lowTemperature))℃"
                self.highTemperatureLabel.text = "H: " + "\(Int(highTemperature))℃"
            }
            self.descriptionLabel.text = self.weatherDetails?.first?.weather[0].description.capitalized
            self.dailyWeatherDataTableView.reloadData()
        }
    }
}

// MARK: Tablebiew DataSource methods extension
extension WeatherViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherDetails?.count ?? 0
    }
        
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let weatherDetailCell = tableView.dequeueReusableCell(withIdentifier: WeatherDetailsTableViewCell.cellIdentifier, for: indexPath)
                as? WeatherDetailsTableViewCell,
              let weatherDetails = self.weatherDetails else {
                  fatalError("Unexpected Index Path")
              }
        
        weatherDetailCell.configureCell(with: weatherDetails, index: indexPath.row)
        weatherDetailCell.backgroundColor = .clear
        return weatherDetailCell
    }
}

// MARK: Tablebiew delegate method extension
extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// MARK: Textfield delegate method extension
extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let cityName = textField.text {
            self.weatherData?.getCityCoordinate(from: cityName)
        }
        textField.text = ""
        return true
    }
}
