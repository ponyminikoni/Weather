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
        getWeather(for: "Moscow")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func showBottonPressed() {
        getWeather(for: cityNameTextFiled.text)
        cityNameTextFiled.text = nil
    }
    
    private func getWeather(for city: String?) {
        NetworkManager.shared.getData(city: city ?? "") { weather in
            self.cityNameLabel.text = weather.name
            self.tempCurrentLabel.text = String(format: "%.0f", weather.main.temp) + "℃"
            
            self.tempMinLabel.text = "Min: " + String(format: "%.0f", weather.main.tempMin ) + "℃"
            
            self.tempMaxLabel.text = "Max " + String(format: "%.0f", weather.main.tempMax ) + "℃"
            
        }
    }
}

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        cityNameTextFiled.resignFirstResponder()
        
        if let cityName = cityNameTextFiled.text {
            getWeather(for: cityName)
            cityNameTextFiled.text = nil
        }
        return true
    }
    
}
