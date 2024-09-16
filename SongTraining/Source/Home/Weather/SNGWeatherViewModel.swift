//
//  SNGWeatherViewModel.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import Foundation
import WSRUtils

final class SNGWeatherViewModel {
    var isLoading: WSRObservableObject<Bool> = WSRObservableObject(false)
    var error: WSRObservableObject<String> = WSRObservableObject("")
    
    var weatherDetails: WSRObservableObject<SNGWeatherDisplayModel> = WSRObservableObject(SNGWeatherDisplayModel())
    
    let cities = ["Mandaluyong", "Caloocan",
                  "Dasmarinas", "Laoag City",
                  "Makati", "Quezon City",
                  "Manila", "Muntinlupa",
                  "Taguig", "Cebu"]
    
    let defaultCity = "Manila"
    
    func getWeather(from city: String) async {
        self.isLoading.value = true
        
        do {
            let details = try await WSRApiService().getWeather(from: city.lowercased())
            
            self.isLoading.value = false
            self.error.value = ""
            
            weatherDetails.value = SNGWeatherDisplayModel(
                description: details.data.descriptions.description,
                temperature: Int(details.data.temperature),
                image: details.data.descriptions.main.capitalized.replacingOccurrences(of: " ", with: "")
            )
        }
        catch(let error) {
            if let error = error as? WSRApiError {
                wsrLogger.api(message: error.description)
                
                if error.description == WSRApiError.badRequest.description {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.badRequest.rawValue
                }
                else {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.somethingWentWrong.rawValue
                }
            }
            else {
                wsrLogger.api(message: "\(error.localizedDescription)")
                
                self.isLoading.value = false
                self.error.value = SNGErrorAlertType.domain.rawValue
            }
        }
    }
    
}
