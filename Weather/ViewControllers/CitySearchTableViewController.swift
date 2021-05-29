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
        cell.cityID = filteredCitiesList[indexPath.row].id
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath) as! CityInfoTableViewCell
        guard let cityID = selectedCell.cityID else { return }
        delegate.setValue(for: cityID)
        dismiss(animated: true, completion: nil)
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
