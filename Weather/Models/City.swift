//
//  City.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 27.05.2021.
//

import Foundation

struct City: Decodable {
    let coord: Coordinate
    let country, name: String
}

struct Coordinate: Decodable {
    let lat, lon: Double
}
