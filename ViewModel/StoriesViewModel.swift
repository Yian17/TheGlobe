//
//  StoriesViewModel.swift
//  TheGlobe
//
//  Created by Wu Yian on 2024-08-13.
//

import Foundation
import UIKit

class StoriesViewModel {
    struct Constant {
        static let storiesEndPoint = "https://d2c9087llvttmg.cloudfront.net/trending_and_sophi/recommendations.json"
    }
        
    var stories: [RecommendationModel] = []
    
    // Error message for Testing Purpose
    var errorMessage: String?
    private let serviceProvider: ServiceProtocol
    
    /// Initializes StoriesViewModel with a service provider
    /// - Parameter serviceProvider: The service provider for network requests
    init(serviceProvider: ServiceProtocol = Service()) {
        self.serviceProvider = serviceProvider
    }
    
    /// Returns the number of stories
    /// - Returns: The count of stories
    func getNumberOfRowsInSection() -> Int {
        return stories.count
    }
    
    /// Returns a StoryCellViewModel for a specific index
    /// - Parameter index: The index of the story
    /// - Returns: A StoryCellViewModel for the story at the given index
    func story(at index: Int) -> StoryCellViewModel {
        StoryCellViewModel(recommendation: stories[index])
    }
    
    func fetchStories() async {
        do {
            let stories = try await serviceProvider.fetchStories(urlString: Constant.storiesEndPoint)
            self.stories = stories.recommendations
        } catch let error as RequestError {
            self.errorMessage = error.errorMessage
        } catch {
            // Handle any other types of errors
            self.errorMessage = error.localizedDescription
        }
    }
}

class StoryCellViewModel {
    private let recommendation: RecommendationModel
    
    var imageData: Data?
    
    var serviceProvider: ServiceProtocol
    
    /// Initializes StoryCellViewModel with a recommendation and service provider
    /// - Parameters:
    ///   - recommendation: The story recommendation model
    ///   - serviceProvider: The service provider for network requests
    init(recommendation: RecommendationModel, serviceProvider: ServiceProtocol = Service()) {
        self.recommendation = recommendation
        self.serviceProvider = serviceProvider
    }
    
    var headline: String {
        recommendation.title
    }
    
    var authors: String {
        recommendation.authors.joined(separator: ", ")
    }
    
    var isProtectionProduct: Bool {
        recommendation.protectionProduct == "red"
    }
    
    /// Returns an attributed string for the headline, with a red "X" if it's a protected product
    var attributedHeadline: NSAttributedString {
        let headlineText = NSMutableAttributedString(string: recommendation.title, attributes: [
            .font: UIFont.boldSystemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ])
        
        if isProtectionProduct {
            headlineText.append(NSAttributedString(string: " X", attributes: [
                .font: UIFont.boldSystemFont(ofSize: 18),
                .foregroundColor: UIColor.red
            ]))
        }
        
        return headlineText
    }
    
    /// Fetches the image for the story
    /// - Returns: The image data
    /// - Throws: RequestError if the image fetch fails
    func fetchImage() async throws -> Data {
        guard let urlString = recommendation.promoImage?.urls?.size650 else {
            throw RequestError.urlError
        }
        let imageData = try await serviceProvider.fetchImages(urlString: urlString)
        return imageData
    }
}
