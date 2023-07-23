//
//  SNGProfileViewModel.swift
//  SongTraining
//
//  Created by William Rena on 7/3/23.
//

import Foundation

final class SNGProfileViewModel {
    var isLoading: WSRObservableObject<Bool> = WSRObservableObject(false)
    var error: WSRObservableObject<String> = WSRObservableObject("")
    
    var isLoggedOut: WSRObservableObject<Bool> = WSRObservableObject(false)
    
    let authenticatedUserMenuList: [SNGProfileSetting] = [
        SNGProfileSetting(label: "View Profile", image: "Account"),
        SNGProfileSetting(label: "Settings", image: "Settings"),
        SNGProfileSetting(label: "Support", image: "Help"),
        SNGProfileSetting(label: "Logout", image: "Logout")
    ]
        
    let guestUserMenuList: [SNGProfileSetting] = [
        SNGProfileSetting(label: "Sign in"),
        SNGProfileSetting(label: "Sign up")
    ]
    
    private let keychain = SNGKeychainAccess()
    
    func getFullname() -> String? {
        UserDefaults.standard.string(forKey: SNGUserDefaultsKey.fullname.rawValue)
    }
    
    func getUsername() -> String? {
        UserDefaults.standard.string(forKey: SNGUserDefaultsKey.username.rawValue)
    }
    
    func logout() {
        self.isLoading.value = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { [weak self] in
            self?.clearPersistentData()
            
            self?.isLoading.value = false
            self?.error.value = ""
            self?.isLoggedOut.value = true
        }
        
    }
    
    func clearPersistentData() {
        self.keychain.removeItemFromKeychain(for: SNGKeychainAccessKey.token)
        
        SNGUserDefaultsKey.allCases.forEach { key in
            UserDefaults.standard.removeObject(forKey: key.rawValue)
        }
    }
    
    func isAuthenticatedUser() -> Bool {
        return keychain.retrieveHashInKeychain(for: SNGKeychainAccessKey.token) != nil
    }
    
    func getMenuList() -> [SNGProfileSetting] {
        if isAuthenticatedUser() {
            return authenticatedUserMenuList
        }
        else {
            return guestUserMenuList
        }
    }
}
