//
//  SNGBannerModel.swift
//  SongTraining
//
//  Created by William Rena on 7/9/23.
//

import Foundation

struct SNGBannerMediaModel: Codable {
    let data: [SNGMediaDataModel]
}

struct SNGBannerAttributes: Codable {
    let tags: String
    let title: String
    let shortDescription: String
    let url: String?
    
    let updatedAt: String
    let publishedAt: String
    let createdAt: String
    
    let desktopMedia: SNGBannerMediaModel?
}

struct SNGBannerDataModel: Codable {
    let id: Int
    let attributes: SNGBannerAttributes
    
    static func defaultData() -> SNGBannerDataModel {
        let mediaFormat = SNGMediaFormatModel(
            name: "",
            hash: "",
            ext: "",
            mime: "",
            path: "",
            width: 1,
            height: 1,
            size: 1.0,
            url: "")
        let mediaFormats = SNGMediaFormatsModel(
            thumbnail: mediaFormat,
            medium: mediaFormat,
            large: mediaFormat,
            small: mediaFormat)
        let mediaAttributes = SNGMediaAttributesModel(
            name: "",
            alternativeText: "",
            caption: "",
            width: 1,
            height: 1,
            hash: "",
            ext: "",
            mime: "",
            size: 1.0,
            url: "",
            previewUrl: "",
            provider: "",
            createdAt: "",
            updatedAt: "",
            formats: mediaFormats)
        let media = SNGMediaDataModel(
            id: 1,
            attributes: mediaAttributes)
        let bannerMedia = SNGBannerMediaModel(data: [media])
        let attributes = SNGBannerAttributes(tags: "",
                                             title: "Free yourself from the predictable",
                                             shortDescription: "Kinetics - where riding is fun and audacious.",
                                             url: "",
                                             updatedAt: "",
                                             publishedAt: "",
                                             createdAt: "",
                                            desktopMedia: bannerMedia)
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
