//
//  WSRNetwork.swift
//  SongTraining
//
//  Created by William Rena on 7/8/23.
//
// https://medium.com/@popcornomnom/handling-internet-connection-reachability-on-ios-swift-5-2a5cc68fb4b7

import Foundation
import Reachability

protocol WSRNetworkActionDelegate {
    func reachabilityChanged(_ isReachable: Bool)
}

protocol WSRNetworkObserverDelegate: AnyObject, WSRNetworkActionDelegate {
    var reachability: Reachability? { get set }
    
    func addNetworkObserver() throws
    func removeNetworkObserver()
}

extension WSRNetworkObserverDelegate {
    
    /** Subscribe on reachability changing */
    func addNetworkObserver() throws {
        reachability = try! Reachability()
        
        reachability?.whenReachable = { [weak self] reachability in
            //logger.info(message: "Reachable via \(reachability.connection)")
            self?.reachabilityChanged(true)
            
            // notify for with internet connection
            NotificationCenter.default.post(name: .reachabilityChanged, object: true)
        }
        
        reachability?.whenUnreachable = { [weak self] reachability in
            //logger.info(message: "No connection")
            self?.reachabilityChanged(false)
            
            // notify for no internet connection
            NotificationCenter.default.post(name: .reachabilityChanged, object: false)
        }
        
        do {
            try reachability?.startNotifier()
            logger.info(message: "Start notifier reachability!")
        }
        catch {
            logger.error(message: "Cannot start reachability!")
        }
    }
    
    /** Unsubscribe */
    func removeNetworkObserver() {
        reachability?.stopNotifier()
        reachability = nil
    }
}
