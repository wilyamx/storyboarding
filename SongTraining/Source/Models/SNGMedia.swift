//
//  SNGMedia.swift
//  SongTraining
//
//  Created by William Rena on 7/23/23.
//

import Foundation

struct SNGMediaFormatModel: Codable {
    let name: String
    let hash: String
    let ext: String
    let mime: String
    let path: String?
    let width: Int
    let height: Int
    let size: Float
    let url: String
}

struct SNGMediaFormatsModel: Codable {
    let thumbnail: SNGMediaFormatModel
    let medium: SNGMediaFormatModel
    let large: SNGMediaFormatModel
    let small: SNGMediaFormatModel
}

struct SNGMediaAttributesModel: Codable {
    let name: String
    let alternativeText: String
    let caption: String
    let width: Int
    let height: Int
    let hash: String
    let ext: String
    let mime: String
    let size: Float
    let url: String
    let previewUrl: String?
    let provider: String
    let createdAt: String
    let updatedAt: String
    
    let formats: SNGMediaFormatsModel
}

struct SNGMediaData: Codable {
    let id: Int
    let attributes: SNGMediaAttributesModel
}

struct SNGMediaModel: Codable {
    let data: [SNGMediaData]
}



