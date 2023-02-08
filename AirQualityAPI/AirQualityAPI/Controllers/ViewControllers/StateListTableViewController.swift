//
//  StateListTableViewController.swift
//  AirQualityAPI
//
//  Created by Jacob Marillion on 2/5/23.
//

import UIKit

class StateListTableViewController: UITableViewController {
    
    //MARK: - Properties
    var country: String?
    var states: [String] = []

    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchStates()
    }
    
    //MARK: - Helper Functions
    func fetchStates() {
        guard let country = country else { return }
        AirQualityController.fetchStates(forCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let states):
                    self.states = states
                    self.tableView.reloadData()
                case .failure(let error):
                    print("Error on \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stateCell", for: indexPath)
        
        let state = states[indexPath.row]
        
        cell.textLabel?.text = state

        return cell
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toCitiesVC" {
            guard let indexPath = tableView.indexPathForSelectedRow,
                  let destination = segue.destination as? CityListTableViewController
            else { return }
            
            let state = states[indexPath.row]
            
            destination.state = state
            destination.country = country
        }
    }

} //End of class
