//
//  SNGBannerModel.swift
//  SongTraining
//
//  Created by William Rena on 7/9/23.
//

import Foundation

struct SNGBannerAttributes: Codable {
    let tags: String
    let title: String
    let shortDescription: String
    let url: String
    
    let updatedAt: String
    let publishedAt: String
    let createdAt: String
}

struct SNGBannerDataModel: Codable {
    let id: Int
    let attributes: SNGBannerAttributes
    
    static func defaultData() -> SNGBannerDataModel {
        let attributes = SNGBannerAttributes(tags: "",
                                             title: "Free yourself from the predictable",
                                             shortDescription: "Kinetics - where riding is fun and audacious.",
                                             url: "",
                                             updatedAt: "",
                                             publishedAt: "",
                                             createdAt: "")
        return SNGBannerDataModel(id: 0,
                                  attributes: attributes)
    }
}

struct SNGBannerModel: Codable {
    let data: [SNGBannerDataModel]
    let meta: SNGMetaModel
    let disclaimer: String
    
    static func defaultData() -> SNGBannerModel {
        let pagination = SNGPaginationDetailsModel(pageCount: 0,
                                                   pageSize: 0,
                                                   total: 0,
                                                   page: 0)
        let data = [SNGBannerDataModel]()
        let meta = SNGMetaModel(pagination: pagination)
        return SNGBannerModel(data: data,
                              meta: meta,
                              disclaimer: "")
    }
}
