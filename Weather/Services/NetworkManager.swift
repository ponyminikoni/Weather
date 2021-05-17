//
//  NetworkManager.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import Foundation

class NetworkManager {
    
    func getData(city: String, complition: @escaping (WeatherResponse) -> ()) {
        
        let baseURL = "http://api.openweathermap.org/data/2.5/weather?q=\(city)&units=metric&appid="
        let apiKey = "99778f189f239059899e125db87af0d0"
        
        guard let url = URL(string: baseURL + apiKey) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error { print(error); return }
            guard let data = data else {return}
            
            do {
                let weather = try JSONDecoder().decode(WeatherResponse.self , from: data)
                DispatchQueue.main.async {
                    complition(weather)
                }
            } catch let error {
                print(error)
            }
        }.resume()
    }
}
