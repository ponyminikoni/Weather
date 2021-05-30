//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import UIKit
import CoreLocation

protocol SearchTableViewControllerDelegate {
    func setValue(for cityID: Int)
}

class WeatherInfoViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempCurrentLabel: UILabel!
    @IBOutlet var tempMinLabel: UILabel!
    @IBOutlet var tempMaxLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    
    private var cityID = 524901 {
        didSet {
            showWeather()
        }
    }
    
//    let locationManager = CLLocationManager()
//    var currentLocation: CLLocation?
//
//    func setupLocation() {
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//        locationManager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if !locations.isEmpty, currentLocation == nil {
//            currentLocation = locations.first
//            locationManager.stopUpdatingLocation()
//            requestWeatherForLocation()
//        }
//    }
//
//    func requestWeatherForLocation() {
//        guard let currentLocation = currentLocation else { return }
//        let long = currentLocation.coordinate.longitude
//        let lat = currentLocation.coordinate.latitude
//
//        print(long, lat)
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        showWeather()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        setupLocation()
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let citySearchTableVC = segue.destination as? CitySearchTableViewController else { return }
        citySearchTableVC.delegate = self
    }
    
    private func showWeather() {
        NetworkManager.shared.fetchWeather(cityID: cityID) { weather in
            self.checkWeatherDataState(data: weather)
        }
    }
    
    private func checkWeatherDataState(data: WeatherResponse?) {
        guard let weather = data else { self.showAlert(); return }
        setWeatherInfo(weather: weather)
    }
    
    private func setWeatherInfo(weather: WeatherResponse) {
        self.cityNameLabel.text = weather.name
        self.weatherDescriptionLabel.text = weather.weather.first?.main
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
    func setValue(for cityID: Int) {
        self.cityID = cityID
    }
}
