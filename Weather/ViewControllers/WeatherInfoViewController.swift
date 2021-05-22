//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import UIKit

class WeatherInfoViewController: UIViewController {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempCurrentLabel: UILabel!
    @IBOutlet var tempMinLabel: UILabel!
    @IBOutlet var tempMaxLabel: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    
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
    
    @IBAction func searchBottonPressed() {
        showWeather()
    }
    
    private func showWeather() {
        NetworkManager.shared.getData(city: cityNameTextFiled.text) { weatherResponse in
            self.checkWeatherDataState(data: weatherResponse)
        }
        self.cityNameTextFiled.text = nil
    }
    
    private func checkWeatherDataState(data: WeatherResponse?) {
        guard let data = data else { self.showAlert(); return }
            self.setWeatherUI(weather: data)
    }
    
    private func setWeatherUI(weather: WeatherResponse) {
        self.cityNameLabel.text = weather.name
        self.weatherDescription.text = weather.weather.first?.main
        self.tempCurrentLabel.text = String(format: "%.0f", weather.main.temp) + "°"
        self.tempMinLabel.text = String(format: "L: %.0f", weather.main.tempMin) + "°"
        self.tempMaxLabel.text = String(format: "H: %.0f", weather.main.tempMax) + "°"
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "City Not Found", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension WeatherInfoViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityNameTextFiled.resignFirstResponder()
        showWeather()
        return true
    }
}
