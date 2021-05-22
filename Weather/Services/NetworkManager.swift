//
//  NetworkManager.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func getData(city: String?, completion: @escaping (WeatherResponse) -> ()) {
        
        let stringURL = "http://api.openweathermap.org/data/2.5/weather?q=\(city ?? "")&units=metric&appid=99778f189f239059899e125db87af0d0"
        
        guard let url = URL(string: stringURL) else { return }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error { print(error); return }
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let weatherResponse = try decoder.decode(WeatherResponse.self , from: data)
                DispatchQueue.main.async {
                    completion(weatherResponse)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        }.resume()
    }
}
