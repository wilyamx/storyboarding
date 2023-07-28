//
//  SNGProfileDetailsViewModel.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import Foundation

final class SNGProfileDetailsViewModel {
    var isLoading: WSRObservableObject<Bool> = WSRObservableObject(false)
    var error: WSRObservableObject<String> = WSRObservableObject("")
    
    var userDetails: WSRObservableObject<SNGUserModel> = WSRObservableObject(SNGUserModel.defaultData())
    
    private let keychain = SNGKeychainAccess()
    
    // MARK: - Networking
    
    func getUserDetails() async {
        self.isLoading.value = true
        
        do {
            let details = try await WSRApiService().getUserDetails()
            userDetails.value = details
            
            self.isLoading.value = false
            self.error.value = ""
        }
        catch(let error) {
            if let error = error as? WSRApiError {
                logger.api(message: error.description)
                
                if error.description == WSRApiError.badRequest.description {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.badRequest.rawValue
                }
                else {
                    self.isLoading.value = false
                    self.error.value = SNGErrorAlertType.somethingWentWrong.rawValue
                }
            }
        }
    }
    
    // MARK: - Other Methods
    
    func isAuthenticatedUser() -> Bool {
        return keychain.retrieveHashInKeychain(for: SNGKeychainAccessKey.token) != nil
    }
    
}
