//
//  SNGWeatherApis.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import Foundation

extension WSRApiService {
    func getWeather(from city: String) async throws -> SNGWeatherModel {
        let urlString = SNGApiEndpoints.getWeathers.stringWithDomainUrl()
        
        guard var url = URL(string: urlString) else {
            throw WSRApiError.badURL
        }
        
        let queryItems = [
            URLQueryItem(name: "city", value: city),
            URLQueryItem(name: "units", value: "metric"),
        ]
        url.append(queryItems: queryItems)
        
        let session = URLSession(configuration: WSRApiService.getURLSessionConfiguration())
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
#if DEV
        request.addValue("200", forHTTPHeaderField: "x-mock-response-code")
#endif
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw WSRApiError.serverError
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            if (400...499).contains(httpResponse.statusCode) {
                throw WSRApiError.badRequest
            }
            else if (500...599).contains(httpResponse.statusCode) {
                throw WSRApiError.serverError
            }
            else {
                throw WSRApiError.badResponse(statusCode: httpResponse.statusCode)
            }
        }
        
        logger.api(request: request, httpResponse: httpResponse, data: data)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SNGWeatherModel.self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
}
