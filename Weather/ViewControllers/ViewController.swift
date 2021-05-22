//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempCurrentLabel: UILabel!
    @IBOutlet var tempMinLabel: UILabel!
    @IBOutlet var tempMaxLabel: UILabel!
    
    @IBOutlet var searchButton: UIButton!
    @IBOutlet var cityNameTextFiled: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityNameTextFiled.text = "Moscow"
        showWeather()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func showBottonPressed() {
        showWeather()
    }
    
    private func setWeatherUI(weather: WeatherResponse) {
        self.cityNameTextFiled.text = nil
        self.cityNameLabel.text = weather.name
        self.tempCurrentLabel.text = String(format: "%.0f", weather.main.temp) + "℃"
        self.tempMinLabel.text = "Min: " + String(format: "%.0f", weather.main.tempMin ) + "℃"
        self.tempMaxLabel.text = "Max " + String(format: "%.0f", weather.main.tempMax ) + "℃"
    }
    
    
    private func showWeather() {
        NetworkManager.shared.getData(city: cityNameTextFiled.text) { weatherResponse in
            self.setWeatherUI(weather: weatherResponse)
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityNameTextFiled.resignFirstResponder()
        showWeather()
        return true
    }
    
}
