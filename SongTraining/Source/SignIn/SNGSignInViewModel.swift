//
//  SNGSignInViewModel.swift
//  SongTraining
//
//  Created by William Rena on 6/28/23.
//

import Foundation

public enum SNGUserDefaultsKey: String, CaseIterable {
    case username = "SNGUsername"
    case fullname = "SNGFullname"
    case loginAsGuest = "SNGLoginAsGuest"
}

final class SNGSignInViewModel {
    
    var isLoading: WSRObservableObject<Bool> = WSRObservableObject(false)
    var error: WSRObservableObject<String> = WSRObservableObject("")
    var isLoggedIn: WSRObservableObject<Bool> = WSRObservableObject(false)
    
    let keychainAccess = SNGKeychainAccess()
    
    func login(email: String, password: String) async {
        self.isLoading.value = true
        
        do {
            let loginDetails = try await WSRApiService().login(username: email,
                                                               password: password)
            
            // secured token stored
            keychainAccess.storeHashInKeychain(key: SNGKeychainAccessKey.token,
                                                    value: loginDetails.jwt)
            
            // stored user info
            UserDefaults.standard.set(loginDetails.user.username,
                                      forKey: SNGUserDefaultsKey.username.rawValue)
            UserDefaults.standard.set("\(loginDetails.user.firstname) \(loginDetails.user.lastname)",
                                      forKey: SNGUserDefaultsKey.fullname.rawValue)
            
            self.isLoading.value = false
            self.error.value = ""
            self.isLoggedIn.value = true
            
            logger.api(message: "Login complete!")
        }
        catch(let error) {
            if let error = error as? WSRApiError {
                logger.error(message: error.localizedDescription)
            }
            
            self.isLoading.value = false
            self.error.value = SNGErrorAlertType.somethingWentWrong.rawValue
            self.isLoggedIn.value = false
        }
        
    }
    
    func loginAsGuest() {
        UserDefaults.standard.set(true,
                                  forKey: SNGUserDefaultsKey.loginAsGuest.rawValue)
    }
    
    func loginWithError(email: String, password: String) {
        self.isLoading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isLoading.value = false
            self.error.value = SNGErrorAlertType.noInternetConnection.rawValue
        }
    }
    
    /**
        Remember Me
     */
    func checkForLoginUser() {
        self.isLoggedIn.value = isAuthenticatedUser() || isGuestUser()
    }
    
    func isAuthenticatedUser() -> Bool {
        return keychainAccess.retrieveHashInKeychain(for: SNGKeychainAccessKey.token) != nil
    }
    
    func isGuestUser() -> Bool {
        return UserDefaults.standard.bool(forKey: SNGUserDefaultsKey.loginAsGuest.rawValue)
    }
    
    func deleteAllPersistentData() {
        keychainAccess.removeItemFromKeychain(for: SNGKeychainAccessKey.token)
        
        SNGUserDefaultsKey.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
        
    }
}
