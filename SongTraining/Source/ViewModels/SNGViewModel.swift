//
//  SNGViewModel.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import Foundation

class SNGViewModel {
    var service: WSRApiServiceProtocol
    
    init(service: WSRApiServiceProtocol = WSRApiService()) {
       self.service = service
    }
}
