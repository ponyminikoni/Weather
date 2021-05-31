//
//  SearchTableViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 27.05.2021.
//

import UIKit

class CitySearchTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    private var citiesList: [City] = CitiesListManager.shared.fetchCitiesList()
    private var filteredCitiesList: [City] = []
    
    var delegate: SearchTableViewControllerDelegate!
    
    override func viewDidLoad() {
        searchBar.becomeFirstResponder()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCitiesList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityInfoTableViewCell
        
        cell.cityNameLabel.text = filteredCitiesList[indexPath.row].name
        cell.countryNameLabel.text = filteredCitiesList[indexPath.row].country
        cell.lat = filteredCitiesList[indexPath.row].coord.lat
        cell.lon = filteredCitiesList[indexPath.row].coord.lon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CityInfoTableViewCell
        guard let lat = selectedCell.lat else { return }
        guard let lon = selectedCell.lon else { return }
        delegate.setValue(lat: lat, lon: lon, cityName: selectedCell.cityNameLabel.text ?? "")
        self.dismiss(animated: true, completion: nil)
    }
}

extension CitySearchTableViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCitiesList = citiesList.filter { item in item.name.contains(searchText) }
        self.tableView.reloadData()
    }
}
