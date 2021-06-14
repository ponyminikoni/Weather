//
//  SearchTableViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 27.05.2021.
//

import UIKit

class CitySearchTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    private var citiesList: [City] = []
    private var filteredCitiesList: [City] = []
    
    var delegate: SearchTableViewControllerDelegate!
    
    override func viewDidLoad() {
        setupCitiesList()
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
        let filtredCity = filteredCitiesList[indexPath.row]
        cell.cityNameLabel.text = filtredCity.name
        cell.countryNameLabel.text = filtredCity.country
        cell.lat = filtredCity.coord.lat
        cell.lon = filtredCity.coord.lon
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CityInfoTableViewCell
        guard let lat = selectedCell.lat,
              let lon = selectedCell.lon,
              let cityName = selectedCell.cityNameLabel.text
        else { return }
        delegate.setValue(lat: lat, lon: lon, cityName: cityName)
        self.dismiss(animated: true, completion: nil)
    }
    
    private func setupCitiesList() {
        DispatchQueue.global().async {
            self.citiesList = CitiesListManager.shared.fetchCitiesList()
        }
    }
}

extension CitySearchTableViewController : UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCitiesList = citiesList.filter { item in item.name.localizedStandardContains(searchText) }
        self.tableView.reloadData()
    }
}
