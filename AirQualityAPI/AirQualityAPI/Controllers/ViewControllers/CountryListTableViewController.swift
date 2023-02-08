//
//  CountryListTableViewController.swift
//  AirQualityAPI
//
//  Created by Jacob Marillion on 2/5/23.
//

import UIKit

class CountryListTableViewController: UITableViewController {
    
    //MARK: - Properties
    var countries: [String] = []
    
    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchCountries()
    }
    
    //MARK: - Helper Functions
    func fetchCountries() {
        AirQualityController.fetchCountries { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let countries):
                    self.countries = countries
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error on \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath)
        
        let country = countries[indexPath.row]
        
        cell.textLabel?.text = country

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toStatesVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let desination = segue.destination as? StateListTableViewController
            else { return }
            
            let country = countries[indexPath.row]
            
            desination.country = country
        }
    }

} //End of class
