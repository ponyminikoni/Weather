//
//  WeatherResponse.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import Foundation

struct WeatherResponse: Decodable {
    let weather: [Weather]
    let main: Main
    let wind: Wind
    let name: String
}
struct Main: Decodable {
    let temp: Float
    let tempMin: Float
    let tempMax: Float
}

struct Wind: Decodable {
    let speed : Float
}

struct Weather: Decodable {
    let main: String
}
