//
//  SNGWeatherModel.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import Foundation

struct SNGWeatherDescription: Codable {
    let main: String
    let description: String
}

struct SNGWeatherDetailsModel: Codable {
    let cityName: String
    let country: String
    let temperature: Double
    let feelsLike: Double
    let temperatureMin: Double
    let temperatureMax: Double
    let pressure: Int
    let humidity: Int
    let descriptions: SNGWeatherDescription
}

struct SNGWeatherModel: Codable {
    let data: SNGWeatherDetailsModel
    let disclaimer: String
}

// MARK: - For Display

struct SNGWeatherDisplayModel {
    let description: String?
    let temperature: Int?
    let image: String?
    
    init(description: String? = nil,
         temperature: Int? = nil,
         image: String? = nil) {
        
        self.description = description
        self.temperature = temperature
        self.image = image
    }
}
