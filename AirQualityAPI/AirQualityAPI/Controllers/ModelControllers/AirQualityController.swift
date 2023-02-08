//
//  AirQualityController.swift
//  AirQualityAPI
//
//  Created by Jacob Marillion on 2/5/23.
//

import Foundation

class AirQualityController {
    
    //MARK: - String Constants
    static let baseURL = URL(string: "https://api.airvisual.com")
    static let versionComponent = "v2"
    static let countriesComponent = "countries"
    static let statesComponent = "states"
    
    static let countryKey = "country"
    static let statesKey = "state"
    
    static let citiesComponent = "cities"
    
    static let cityComponent = "city"
    static let cityKey = "city"
    
    static let apiKeyKey = "key"
    static let apiKeyValue = "bd8e4477-100f-4188-b833-4e41bb9a7aa0"
    
    //Fetch Countries
    //Builds http://api.airvisual.com/v2/countries?key={{YOUR_API_KEY}}
    static func fetchCountries(completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let countriesURL = versionURL.appendingPathComponent(countriesComponent)
        
        var components = URLComponents(url: countriesURL, resolvingAgainstBaseURL: true)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(Country.self, from: data)
                let countryDicts = topLevelObject.data
                var listOfCountryNames: [String] = []
                for country in countryDicts {
                    let countryName = country.countryName
                    listOfCountryNames.append(countryName)
                }
                return completion(.success(listOfCountryNames))
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    //Fetch states in county
    //Builds http://api.airvisual.com/v2/states?country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchStates(forCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let statesURL = versionURL.appendingPathComponent(statesComponent)
        
        var components = URLComponents(url: statesURL, resolvingAgainstBaseURL: true)
        let countryQuery = URLQueryItem(name: countryKey, value: forCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(State.self, from: data)
                let stateDicts = topLevelObject.data
                
                var listOfStateNames: [String] = []
                
                for state in stateDicts {
                    let stateName = state.stateName
                    listOfStateNames.append(stateName)
                }
                return completion(.success(listOfStateNames))
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
        
    //Fetch cities in a state
    //Builds http://api.airvisual.com/v2/cities?state={{STATE_NAME}}&country={{COUNTRY_NAME}}&key={{YOUR_API_KEY}}
    static func fetchCities(forState: String, inCountry: String, completion: @escaping (Result<[String], NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let citiesURL = versionURL.appendingPathComponent(citiesComponent)
        
        var components = URLComponents(url: citiesURL, resolvingAgainstBaseURL: true)
        let stateQuery = URLQueryItem(name: statesKey, value: forState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let topLevelObject = try JSONDecoder().decode(City.self, from: data)
                let cityDicts = topLevelObject.data
                
                var listOfCityNames: [String] = []
                
                for city in cityDicts {
                    let cityName = city.cityName
                    listOfCityNames.append(cityName)
                }
                return completion(.success(listOfCityNames))
            } catch let error {
                print(error)
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }
    
    //Fetch specificed city data
    //Builds http://api.airvisual.com/v2/city?city=Los Angeles&state=California&country=USA&key={{YOUR_API_KEY}}
    static func fetchData(forCity: String, inState: String, inCountry: String, completion: @escaping (Result<CityData, NetworkError>) -> Void) {
        guard let baseURL = baseURL else { return completion(.failure(.invalidURL)) }
        let versionURL = baseURL.appendingPathComponent(versionComponent)
        let cityURL = versionURL.appendingPathComponent(cityComponent)
        
        var components = URLComponents(url: cityURL, resolvingAgainstBaseURL: true)
        let cityQuery = URLQueryItem(name: cityKey, value: forCity)
        let stateQuery = URLQueryItem(name: statesKey, value: inState)
        let countryQuery = URLQueryItem(name: countryKey, value: inCountry)
        let apiQuery = URLQueryItem(name: apiKeyKey, value: apiKeyValue)
        components?.queryItems = [cityQuery, stateQuery, countryQuery, apiQuery]
        
        guard let finalURL = components?.url else { return completion(.failure(.invalidURL)) }
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            if let error = error {
                return completion(.failure(.thrownError(error)))
            }
            
            guard let data = data else { return completion(.failure(.noData)) }
            
            do {
                let cityData = try JSONDecoder().decode(CityData.self, from: data)
                
                return completion(.success(cityData))
            } catch {
                return completion(.failure(.unableToDecode))
            }
            
        }.resume()
    }


    
} //End of class
