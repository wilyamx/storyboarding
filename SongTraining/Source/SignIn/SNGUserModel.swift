//
//  SNGUserModel.swift
//  SongTraining
//
//  Created by William Rena on 7/4/23.
//

import Foundation

struct SNGUserModel: Codable {
    let id: Int
    let username: String
    let email: String
    let firstname: String
    let lastname: String
    
    static func defaultData() -> SNGUserModel {
        return SNGUserModel(id: -1,
                            username: "",
                            email: "",
                            firstname: "",
                            lastname: "")
    }
}

struct SNGLoginDetailsModel: Codable {
    let jwt: String
    let disclaimer: String
    let user: SNGUserModel
}
