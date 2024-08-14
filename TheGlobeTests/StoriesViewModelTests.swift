//
//  TheGlobeTests.swift
//  TheGlobeTests
//
//  Created by Wu Yian on 2024-08-13.
//

import XCTest
@testable import TheGlobe

class StoriesViewModelTests: XCTestCase {
    var mockStoriesViewModel: StoriesViewModel?
    var mockService: MockService?
    
    override func setUp() {
        super.setUp()
        mockService = MockService()
        mockStoriesViewModel = StoriesViewModel(serviceProvider: mockService ?? MockService())
    }
    
    override func tearDown() {
        super.tearDown()
        mockStoriesViewModel = nil
        mockService = nil
    }
    
    func testFetchStoriesSuccess() async {
        let stories = StoriesModel(recommendations:[ RecommendationModel(title: "Test Story", authors: ["Test Author"], protectionProduct: "Free")])
        
        mockService?.fetchedStories = stories
        
        await mockStoriesViewModel?.fetchStories()
        
        XCTAssertEqual(mockStoriesViewModel?.stories.count, 1)
        XCTAssertEqual(mockStoriesViewModel?.stories.first?.title, "Test Story")
        XCTAssertNil(mockStoriesViewModel?.errorMessage)
    }
    
    func testFetchStoriesFailure() async {
        mockService?.shouldSucceed = false
        
        await mockStoriesViewModel?.fetchStories()
        
        XCTAssertTrue(mockStoriesViewModel?.stories.isEmpty ?? false)
        XCTAssertEqual(mockStoriesViewModel?.errorMessage, "No data received")
    }

    func testGetNumberOfRowsInSection() async {
        let stories = StoriesModel(recommendations: [
            RecommendationModel(title: "Test Story 1", authors: ["Test Author"], protectionProduct: "Free", promoImage: nil),
            RecommendationModel(title: "Test Story 2", authors: ["Test Author"], protectionProduct: "Free", promoImage: nil)
        ])
        mockService?.fetchedStories = stories
        
        await mockStoriesViewModel?.fetchStories()
        
        XCTAssertEqual(mockStoriesViewModel?.getNumberOfRowsInSection(), 2)
    }
}

class MockService: ServiceProtocol {
    var shouldSucceed = true
    var fetchedStories: StoriesModel?
    var imageData: Data?
    
    func fetchStories(urlString: String) async throws -> TheGlobe.StoriesModel {
        if shouldSucceed, let stories = fetchedStories {
            return stories
        } else {
            throw RequestError.noData
        }
    }
    
    func fetchImages(urlString: String) async throws -> Data {
        if shouldSucceed, let imageData = imageData {
            return imageData
        } else {
            throw RequestError.noData
        }
    }
}
