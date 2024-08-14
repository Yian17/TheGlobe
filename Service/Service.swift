//
//  Service.swift
//  TheGlobe
//
//  Created by Wu Yian on 2024-08-13.
//

import Foundation

enum RequestError: Error {
    case urlError          // Invalid URL
    case noData            // No data received
    case decodeError       // Error decoding the received data
    case serializeError    // Error serializing the request body
    case noResponse        // No response received
    
    var errorMessage: String {
        switch self {
        case .urlError:
            return "Invalid URL"
        case .noData:
            return "No data received"
        case .decodeError:
            return "Error decoding the received data"
        case .serializeError:
            return "Error serializing the request body"
        case .noResponse:
            return "No response received"
        }
    }
}

protocol ServiceProtocol {    
    func fetchStories(urlString: String) async throws -> StoriesModel
    func fetchImages(urlString: String) async throws -> Data
}


class Service: ServiceProtocol {    
    enum RequestType: String {
        case post = "POST"
        case get = "GET"
        case put = "PUT"
        case delete = "DELETE"
    }
    
    var urlSession: URLSession
    
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
    /// Performs a network request and decodes the response
    /// - Parameters:
    ///   - urlString: The URL string for the request
    ///   - requestType: The HTTP request type
    ///   - body: The request body (optional)
    /// - Returns: The decoded response of type T
    /// - Throws: RequestError if the request fails
    func request<T: Decodable> (urlString: String,
                                requestType: RequestType = .get,
                                body: [String: Any]? = nil) async throws -> T {
        guard let url = URL(string: urlString) else {
            throw RequestError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        
        if let body = body {
            do {
                request.httpBody = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            } catch {
                throw RequestError.serializeError
            }
        }
        
        let (data, _) = try await urlSession.data(for: request)
        
        if T.self is Data.Type, let data = data as? T {
            return data
        }
        
        do {
            let decodedObject = try JSONDecoder().decode(T.self, from: data)
            return decodedObject
        } catch {
            throw RequestError.decodeError
        }
    }
    
    /// Fetches image data from a URL
    /// - Parameter urlString: The URL string of the image
    /// - Returns: The image data
    /// - Throws: RequestError if the fetch fails
    func fetchImages(urlString: String) async throws -> Data {
        return try await request(urlString: urlString)
    }
    
    /// Fetches stories from a URL
    /// - Parameter urlString: The URL string of the stories endpoint
    /// - Returns: A StoriesModel containing the fetched stories
    /// - Throws: RequestError if the fetch fails
    func fetchStories(urlString: String) async throws -> StoriesModel {
        return try await request(urlString: urlString)
    }
}
