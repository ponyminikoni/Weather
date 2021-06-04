//
//  WeatherResponse.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import Foundation

struct WeatherResponse: Decodable {
    let current: Current
}

struct Current: Decodable {
    let weather: [Weather]
    let temp: Float
}
struct Weather: Decodable {
    let main, icon: String
}
