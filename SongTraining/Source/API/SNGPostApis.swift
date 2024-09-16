//
//  SNGPostApis.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import Foundation

extension WSRApiService {
    func getPosts() async throws -> SNGPostDataModel {
        let urlString = SNGApiEndpoints.getPosts.stringWithDomainUrl()
       
        guard var url = URL(string: urlString) else {
            throw WSRApiError.badURL
        }
        
        let queryItems = [
            URLQueryItem(name: "populate", value: "media"),
            URLQueryItem(name: "sort", value: "publishedAt:desc")
        ]
        url.append(queryItems: queryItems)
        
        let session = URLSession(configuration: WSRApiService.getURLSessionConfiguration())
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("200", forHTTPHeaderField: "x-mock-response-code")
        
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
            return try decoder.decode(SNGPostDataModel.self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
}
