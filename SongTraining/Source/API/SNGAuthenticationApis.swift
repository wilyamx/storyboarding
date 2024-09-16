//
//  SNGAuthenticationApis.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import Foundation

extension WSRApiService {
    
    // FIXME: JSONError when credentials are incorrect
    
    func login(username: String, password: String) async throws -> SNGLoginDetailsModel {
        let urlString = SNGApiEndpoints.authentication.stringWithDomainUrl()
        
        guard let url = URL(string: urlString) else {
            throw WSRApiError.badURL
        }
        
        let parameters = ["identifier": username, "password": password]
        
        let session = URLSession(configuration: WSRApiService.getURLSessionConfiguration())
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
        } catch {
            throw WSRApiError.badRequest
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
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
            return try decoder.decode(SNGLoginDetailsModel.self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
    
    func getUserDetails() async throws -> SNGUserModel {
        let urlString = SNGApiEndpoints.getUserDetails.stringWithDomainUrl()
       
        guard let url = URL(string: urlString) else {
            throw WSRApiError.badURL
        }
        
        guard let token = SNGKeychainAccess().retrieveHashInKeychain(for: SNGKeychainAccessKey.token) else {
            throw WSRApiError.badRequest
        }
        
        let session = URLSession(configuration: WSRApiService.getURLSessionConfiguration())
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.addValue("400", forHTTPHeaderField: "x-mock-response-code")
        
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
            return try decoder.decode(SNGUserModel.self, from: data)
        }
        catch(let error) {
            throw WSRApiError.parsing(error as? DecodingError)
        }
    }
}
