//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import UIKit
import CoreLocation
import Lottie

protocol SearchTableViewControllerDelegate {
    func setValue(lat: Double, lon: Double, cityName: String)
}

class WeatherInfoViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempCurrentLabel: UILabel!
    @IBOutlet var tempMinLabel: UILabel!
    @IBOutlet var tempMaxLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    
    @IBOutlet var animationView: AnimationView!
    
    private var cityName = "San Francisco"
    private var lat = 37.774929
    private var lon = -122.419418 {
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
    
    private func setpuAnimation(name: String) {
        animationView.animation = Animation.named(name)
        animationView.loopMode = .loop
        animationView.play()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let citySearchTableVC = segue.destination as? CitySearchTableViewController else { return }
        citySearchTableVC.delegate = self
    }
    
    private func showWeather() {
        NetworkManager.shared.fetchWeather(lat: lat, lon: lon) { weather in
            self.checkWeatherDataState(data: weather)
        }
    }
    
    private func checkWeatherDataState(data: WeatherResponse?) {
        guard let weather = data else { self.showAlert(); return }
        setWeatherInfo(weather: weather)
    }
    
    private func setWeatherInfo(weather: WeatherResponse) {
        var timezone = weather.timezone; replacingCharacters(text: &timezone)
        setpuAnimation(name: weather.current.weather.first?.icon ?? "")
        self.cityNameLabel.text = cityName + ", " + timezone
        self.weatherDescriptionLabel.text = weather.current.weather.first?.main
        self.tempCurrentLabel.text = String(format: "%.0f", weather.current.temp)
    }
    
    private func replacingCharacters(text: inout String) {
        let index = text.firstIndex(of: "/") ?? text.endIndex
        let beginning = text[..<index]
        text = String(beginning)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Weather Info Not Found", message: "", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
}

extension WeatherInfoViewController: SearchTableViewControllerDelegate {
    func setValue(lat: Double, lon: Double, cityName: String) {
        self.cityName = cityName
        self.lat = lat
        self.lon = lon
    }
}
