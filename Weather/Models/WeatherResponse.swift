//
//  WeatherResponse.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 17.05.2021.
//

import Foundation

struct WeatherResponse: Decodable {
    let name: String
    let main: Main
    let wind: Wind
}
struct Main: Decodable {
    let temp: Float?
}

struct Wind: Decodable {
    let speed : Float?
}
