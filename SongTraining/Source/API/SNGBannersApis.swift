//
//  SNGBannersApis.swift
//  SongTraining
//
//  Created by William Rena on 7/9/23.
//

import Foundation
import WSRUtils

extension WSRApiService {
    func getBanners() async throws -> SNGBannerModel {
        let urlString = SNGApiEndpoints.getBanners.stringWithDomainUrl()
        
        guard var url = URL(string: urlString) else {
            throw WSRApiError.badURL
        }
        
        let queryItems = [
            URLQueryItem(name: "populate", value: "desktopMedia"),
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
        
        wsrLogger.api(request: request, httpResponse: httpResponse, data: data)
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(SNGBannerModel.self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
}
