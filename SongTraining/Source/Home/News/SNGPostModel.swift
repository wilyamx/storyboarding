//
//  SNGPost.swift
//  SongTraining
//
//  Created by William Rena on 7/6/23.
//

import Foundation

struct SNGPostAttributes: Codable {
    let author: String?
    let content: String
    let title: String
    let shortDescription: String
    
    let updatedAt: String
    let publishedAt: String
    let createdAt: String
    
    let tags: String?
    
    let media: SNGMediaModel?
}

struct SNGPostModel: Codable {
    let id: Int
    let attributes: SNGPostAttributes
}

struct SNGPostDataModel: Codable {
    let data: [SNGPostModel]
    let disclaimer: String
    let meta: SNGMetaModel
    
    init(data: [SNGPostModel], disclaimer: String, meta: SNGMetaModel) {
        self.data = data
        self.disclaimer = disclaimer
        self.meta = meta
    }
    
    static func defaultData() -> SNGPostDataModel {
        let postAttributes = SNGPostAttributes(author: "",
                                               content: "",
                                               title: "",
                                               shortDescription: "",
                                               updatedAt: "",
                                               publishedAt: "",
                                               createdAt: "",
                                               tags: "",
                                               media: nil)
        let pagination = SNGPaginationDetailsModel(pageCount: 0,
                                                   pageSize: 0,
                                                   total: 0,
                                                   page: 0)
        let data = [SNGPostModel]()
        let meta = SNGMetaModel(pagination: pagination)
        return SNGPostDataModel(data: data,
                                disclaimer: "",
                                meta: meta)
    }
}
