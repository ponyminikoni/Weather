//
//  CityInfoTableViewCell.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 29.05.2021.
//

import UIKit

class CityInfoTableViewCell: UITableViewCell {
    
    @IBOutlet var cityNameLabel: UILabel!
    @IBOutlet var countryNameLabel: UILabel!
    var lat, lon: Double!
}
