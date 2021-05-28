//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import UIKit

protocol SearchTableViewControllerDelegate {
    func setValue(for searchCity: String)
}

class WeatherInfoViewController: UIViewController {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempCurrentLabel: UILabel!
    @IBOutlet var tempMinLabel: UILabel!
    @IBOutlet var tempMaxLabel: UILabel!
    @IBOutlet var weatherDescription: UILabel!
    
    private var searchCity = "" {
        didSet {
            showWeather()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let searchTableVC = segue.destination as? SearchTableViewController else { return }
        searchTableVC.delegate = self
    }
    
    private func showWeather() {
        NetworkManager.shared.fetchWeather(city: searchCity) { weather in
            self.checkWeatherDataState(data: weather)
        }
    }
    
    private func checkWeatherDataState(data: WeatherResponse?) {
        guard let weather = data else { self.showAlert(); return }
        setWeatherInfo(weather: weather)
    }
    
    private func setWeatherInfo(weather: WeatherResponse) {
        self.cityNameLabel.text = weather.name
        self.weatherDescription.text = weather.weather.first?.main
        self.tempCurrentLabel.text = String(format: "%.0f°", weather.main.temp)
        self.tempMinLabel.text = String(format: "L: %.0f°", weather.main.tempMin)
        self.tempMaxLabel.text = String(format: "H: %.0f°", weather.main.tempMax)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Weather Info Not Found", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension WeatherInfoViewController: SearchTableViewControllerDelegate {
    func setValue(for searchCity: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.searchCity = searchCity
        }
    }
}
