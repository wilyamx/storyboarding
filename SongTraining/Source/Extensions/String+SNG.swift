//
//  String+SNG.swift
//  SongTraining
//
//  Created by William Rena on 7/23/23.
//

import Foundation

extension String {
    func stringWithDomainUrl() -> String {
        return "http://localhost:8080\(self)"
    }
}
