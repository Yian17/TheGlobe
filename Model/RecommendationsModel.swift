//
//  RecommendationsModel.swift
//  TheGlobe
//
//  Created by Wu Yian on 2024-08-13.
//

import Foundation


struct StoriesModel: Codable {
    var recommendations: [RecommendationModel]
}

struct RecommendationModel: Codable {
    var title: String
    var authors: [String]
    var protectionProduct: String
    var promoImage: ImageModel?
    
    enum CodingKeys: String, CodingKey {
        case title
        case authors = "byline"
        case protectionProduct = "protection_product"
        case promoImage = "promo_image"
    }
}


struct ImageModel: Codable {
    var urls: URLsModel
}

struct URLsModel: Codable {
    var size650: String
    
    enum CodingKeys: String, CodingKey {
        case size650 = "650"
    }
}
