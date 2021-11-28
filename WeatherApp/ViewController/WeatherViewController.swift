//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Sagar Patil on 27/11/2021.
//

import UIKit

protocol WeatherViewProtocol: AnyObject {
    var weatherData: WeatherDataProtocol? { get set }
    func createWeatherData(details: Forcast, cityName: String)
}

class WeatherViewController: UIViewController, WeatherViewProtocol, Formattable {
    @IBOutlet weak var dailyWeatherDataTableView: UITableView! {
        didSet {
            dailyWeatherDataTableView.register(WeatherDetailsTableViewCell.nib(), forCellReuseIdentifier: WeatherDetailsTableViewCell.cellIdentifier)
            dailyWeatherDataTableView.dataSource = self
            dailyWeatherDataTableView.delegate = self
            dailyWeatherDataTableView.backgroundColor  = .clear
        }
    }
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var searchCityTextField: UITextField!
    @IBOutlet weak var temperatureDetailsStackView: UIStackView!
    
    private var weatherDetails: Forcast?
    var weatherData: WeatherDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.weatherData = WeatherDataLoader()
        self.weatherData?.attachView(view: self)
    }
    
    func createWeatherData(details: Forcast, cityName: String) {
        self.weatherDetails = details
        DispatchQueue.main.async {
            self.dailyWeatherDataTableView.reloadData()
            self.cityNameLabel.text = cityName
            
            if let minimumTemperature = self.weatherDetails?.daily.first?.temp.min,
               let maximumTemperature = self.weatherDetails?.daily.first?.temp.max {
                let lowTemperature = self.convertTemperatureToDegreeCelsius(value: minimumTemperature)
                let highTemperature = self.convertTemperatureToDegreeCelsius(value: maximumTemperature)
                
                self.lowTemperatureLabel.text = "L: " + "\(lowTemperature)"
                self.highTemperatureLabel.text = "H: " + "\(highTemperature)"
            }
        }
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.weatherDetails?.daily.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension WeatherViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let cityName = textField.text {
            self.weatherData?.getCityWeatherData(cityName: cityName)
        }
        return true
    }
}
