//
//  CityDataViewController.swift
//  AirQualityAPI
//
//  Created by Jacob Marillion on 2/5/23.
//

import UIKit

class CityDataViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var cityStateCountryLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var wsLabel: UILabel!
    @IBOutlet weak var tpLabel: UILabel!
    @IBOutlet weak var huLabel: UILabel!
    @IBOutlet weak var latLongLabel: UILabel!
    
    //MARK: - Properties
    var country: String?
    var state: String?
    var city: String?

    //MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchCityData()
    }
    
    func fetchCityData() {
        guard let city = city, let state = state, let country = country else { return }
        AirQualityController.fetchData(forCity: city, inState: state, inCountry: country) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let cityData):
                    self.updateViews(with: cityData)
                case .failure(let error):
                    print("Error on \(#function) : \(error.localizedDescription) \n--\n \(error)")
                }
            }
        }
    }
    
    func updateViews(with cityData: CityData) {
        let data = cityData.data
        
        cityStateCountryLabel.text = "\(data.city), \(data.state), \(data.country)"
        aqiLabel.text = "AQI: \(data.current.pollution.aqius)"
        wsLabel.text = "Windspeed: \(data.current.weather.ws)"
        tpLabel.text = "Temperature: \(data.current.weather.tp)"
        huLabel.text = "Humidity: \(data.current.weather.hu)"
        
        let coordinates = data.location.coordinates
        if coordinates.count == 2 {
            latLongLabel.text = "LAT: \(coordinates[1]) \nLONG: \(coordinates[0])"
        } else {
            latLongLabel.text = "Coordinates unknown.."
        }
    }

} //End of class
