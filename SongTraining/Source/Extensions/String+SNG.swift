//
//  String+SNG.swift
//  SongTraining
//
//  Created by William Rena on 7/23/23.
//

import Foundation

extension String {
    func stringWithDomainUrl() -> String {
        // localhost server
        //return "http://localhost:8080\(self)"
        
        // mock server using postman
        return "https://672ef71b-4337-4ad9-946e-92699848933f.mock.pstmn.io\(self)"
    }
}
