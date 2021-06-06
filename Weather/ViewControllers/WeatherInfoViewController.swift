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
    @IBOutlet var windSpeedLabel: UILabel!
    
    @IBOutlet var locationButton: UIButton!
    
    @IBOutlet var animationView: AnimationView!
    
    private var cityName: String?
    
    private let locationManager = LocationManager.shared
    private var lat: Double?
    private var lon: Double? {
        didSet {
            showWeather()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.setupLocationManager()
        locationManager.didUpdatedLocation = { [self] in
            if locationManager.lat != nil {
                lat = locationManager.lat
                lon = locationManager.lon
                cityName = "Here and Now"
            } else {
                lat = 41.850029
                lon = -87.650047
                cityName = "Chicago"
            }
        }
        setupBackgroundColor(view: view)
        setupBackgroundColor(view: animationView)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let citySearchTableVC = segue.destination as? CitySearchTableViewController else { return }
        citySearchTableVC.delegate = self
    }
    
    private func setupBackgroundColor(view: UIView) {
        view.backgroundColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .light:
                return #colorLiteral(red: 0.9635435939, green: 0.9242141843, blue: 0.924749434, alpha: 1)
            default:
                return #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            }
        }
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
        setpuAnimation(name: weather.current.weather.first?.icon ?? "")
        self.tempCurrentLabel.text = String(format: "%.0f", weather.current.temp)
        self.windSpeedLabel.text = String(format: "%.0f", weather.current.windSpeed)
        self.cityNameLabel.text = cityName
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
