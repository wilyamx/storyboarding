//
//  SNGMetaModel.swift
//  SongTraining
//
//  Created by William Rena on 7/9/23.
//

import Foundation

struct SNGPaginationDetailsModel: Codable {
    let pageCount: Int
    let pageSize: Int
    let total: Int
    let page: Int
}

struct SNGMetaModel: Codable {
    let pagination: SNGPaginationDetailsModel
}
