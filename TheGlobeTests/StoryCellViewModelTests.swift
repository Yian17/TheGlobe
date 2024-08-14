//
//  StoryCellViewModelTests.swift
//  TheGlobeTests
//
//  Created by Wu Yian on 2024-08-13.
//

import XCTest
import Foundation
@testable import TheGlobe

class StoryCellViewModelTests: XCTestCase {
    var mockStoryCellViewModel: StoryCellViewModel?
    var mockService: MockService?
    
    override func setUp() {
        super.setUp()
        mockService = MockService()
        let recommendation = RecommendationModel(title: "Test Story", authors: ["Test Author"], protectionProduct: "Free", promoImage: ImageModel(urls: URLsModel(size650: "http://test.com/image.jpg")))
        mockStoryCellViewModel = StoryCellViewModel(recommendation: recommendation, serviceProvider: mockService ?? MockService())
    }
    
    override func tearDown() {
        super.tearDown()
        mockStoryCellViewModel = nil
        mockService = nil
    }
    
    func testFetchImageSuccess() async {
        let imageData = "Test Image Data".data(using: .utf8)!
        mockService?.imageData = imageData

        let result = try? await mockStoryCellViewModel?.fetchImage()

        XCTAssertEqual(result, imageData)
    }
    
    func testFetchImageFailure() async {
        mockService?.shouldSucceed = false
        
        do {
            _ = try await mockStoryCellViewModel?.fetchImage()
            XCTFail("Expected fetchImage to throw an error")
        } catch {
            XCTAssertEqual(error as? RequestError, .noData)
        }
    }
    
    func testHeadline() {
        XCTAssertEqual(mockStoryCellViewModel?.headline, "Test Story")
    }
    
    func testAuthors() {
        XCTAssertEqual(mockStoryCellViewModel?.authors, "Test Author")
    }
}
