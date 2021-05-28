//
//  CitiesManager.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 28.05.2021.
//

import Foundation

class CitiesManager {
    
    static let shared = CitiesManager() 
    
    private init() {}
    
    func fetchCitiesList() -> [City] {
        let decoder = JSONDecoder()
        guard
            let url = Bundle.main.url(forResource: "Cities", withExtension: "json"),
            let data = try? Data(contentsOf: url),
            let cities = try? decoder.decode([City].self, from: data)
        else { return [] }
        return cities
    }
}
