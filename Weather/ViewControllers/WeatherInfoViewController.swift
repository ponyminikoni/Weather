//
//  ViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import UIKit
import Lottie

protocol SearchTableViewControllerDelegate {
    func setValue(lat: Double, lon: Double, cityName: String)
}

class WeatherInfoViewController: UIViewController {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var tempCurrentLabel: UILabel!
    @IBOutlet var weatherDescriptionLabel: UILabel!
    
    @IBOutlet var locationButton: UIButton!
    
    @IBOutlet var animationView: AnimationView!
    
    private let locationManager = LocationManager.shared
    private var lat: Double?
    private var lon: Double? {
        didSet {
            showWeather()
        }
    }
    
    private var cityName: String? {
        didSet {
            locationButton.setImage(setupButtonImage(systemName: "location"), for: .normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let citySearchTableVC = segue.destination as? CitySearchTableViewController else { return }
        citySearchTableVC.delegate = self
    }
    
    @IBAction func locationButtonTapped() {
        locationManager.setupLocationManager()
        locationManager.didUpdatedLocation = {
            self.lat = self.locationManager.lat
            self.lon = self.locationManager.lon
        }
        locationButton.setImage(setupButtonImage(systemName: "location.fill"), for: .normal)
        cityName = nil
    }
    
    private func setupButtonImage(systemName: String) -> UIImage? {
        let scaleConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: systemName, withConfiguration: scaleConfig)
        return image
    }
    
    private func showWeather() {
        NetworkManager.shared.fetchWeather(lat: lat, lon: lon) { weather in
            self.checkWeatherDataState(data: weather)
        }
    }
    
    private func checkWeatherDataState(data: WeatherResponse?) {
        guard let weather = data else { self.showAlert(); return }
        setupWeatherInfoUI(weather: weather)
    }
    
    private func setupWeatherInfoUI(weather: WeatherResponse) {
        setupBackgroundColor(weather: weather)
        setpuAnimation(name: weather.current.weather.first?.icon ?? "")
        self.cityNameLabel.text = cityName
        self.weatherDescriptionLabel.text = weather.current.weather.first?.main
        self.tempCurrentLabel.text = String(format: "%.0f", weather.current.temp)
    }
    
    private func setupBackgroundColor(weather: WeatherResponse) {
        if weather.current.weather.first?.icon.last == "n" {
            animationView.backgroundColor = #colorLiteral(red: 0.5789809823, green: 0.7002894282, blue: 1, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.5789809823, green: 0.7002894282, blue: 1, alpha: 1)
        } else {
            animationView.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
            view.backgroundColor = #colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)
        }
    }
    
    private func setpuAnimation(name: String) {
        animationView.animation = Animation.named(name)
        animationView.loopMode = .loop
        animationView.play()
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
