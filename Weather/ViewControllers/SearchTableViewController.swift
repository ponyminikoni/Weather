//
//  SearchTableViewController.swift
//  Weather
//
//  Created by Aaron Gulbudagyan on 27.05.2021.
//

import UIKit

class SearchTableViewController: UITableViewController {
    
    @IBOutlet var searchBar: UISearchBar!
    
    private let dataArray = CitiesManager.shared.fetchCitiesList()
    private var filteredArray: [City] = []
    
    var delegate: SearchTableViewControllerDelegate!
    
    
    override func viewDidLoad() {
        searchBar.becomeFirstResponder()
    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let name = filteredArray[indexPath.row].name
        let country = filteredArray[indexPath.row].country
        cell.textLabel?.text = name
        cell.detailTextLabel?.text = country
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCell = tableView.cellForRow(at: indexPath)
        guard var searchCity = selectedCell?.textLabel?.text else { return }
        characterReplacement(for: &searchCity)
        delegate.setValue(for: searchCity)
        dismiss(animated: true, completion: nil)
    }
    
    private func characterReplacement(for text: inout String) {
        text = text.replacingOccurrences(of: " ", with: "+")
    }
}

extension SearchTableViewController : UISearchBarDelegate {

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let text = searchBar.text?.replacingOccurrences(of: " ", with: "")
        filteredArray = dataArray.filter { item in item.name.contains(text ?? "") || item.country.contains(text ?? "") }
        self.tableView.reloadData()
    }
}
