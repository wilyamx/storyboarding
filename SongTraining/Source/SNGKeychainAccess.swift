//
//  SNGKeychainAccess.swift
//  SongTraining
//
//  Created by William Rena on 7/3/23.
//
// https://cocoapods.org/pods/KeychainSwift

import Foundation
import KeychainSwift
import WSRUtils

public enum SNGKeychainAccessKey: String {
    case token = "SNGToken"
}

public class SNGKeychainAccess {
    
    lazy var keychain = KeychainSwift()
    
    public init () {
        
    }
    
    public func storeHashInKeychain(key: SNGKeychainAccessKey, value: String) {
        keychain.set(value, forKey: key.rawValue)
        wsrLogger.cache(message: "storeHashInKeychain for key: \(key.rawValue)")
    }
    
    public func retrieveHashInKeychain(for key: SNGKeychainAccessKey) -> String? {
        keychain.get(key.rawValue)
    }
    
    public func removeItemFromKeychain(for key: SNGKeychainAccessKey) {
        if keychain.delete(key.rawValue) {
            wsrLogger.cache(message: "Delete token success!")
        }
        else {
            wsrLogger.cache(message: "Delete token failed!")
        }
    }
}
