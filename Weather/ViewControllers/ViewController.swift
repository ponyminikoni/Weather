//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    private let networkManager = NetworkManager()
    
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var temperatureLabel: UILabel!
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var cityNameTextFiled: UITextField!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    @IBAction func getWeather() {
        if self.cityNameTextFiled.text == "" {
            self.cityNameLabel.text = "No Data"
            self.temperatureLabel.text = "🤷🏽‍♀️"
        }
        networkManager.getData(city: cityNameTextFiled.text ?? "") { weather in
            self.cityNameLabel.text = weather.name
            self.temperatureLabel.text = String(format: "%.0f", weather.main.temp ?? 0)
        }
    }
    
}

