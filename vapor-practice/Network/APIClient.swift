//
//  APIClient.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import Foundation
import Combine

struct APIClient {
    @discardableResult
    func fetch<T: Decodable>(request: URLRequest) async throws -> T {
        let session = URLSession.shared
        let (data, _) = try await session.data(for: request)
        let decoder: JSONDecoder = .init()
        return try decoder.decode(T.self, from: data)
    }
    
    @discardableResult func load<T: Decodable>(request: URLRequest) throws -> T {
        let cache = URLCache.shared
        let response = cache.cachedResponse(for: request)
        guard let data = response?.data
        else {
            throw APIClientError.cannotLoadFromCache
        }
        let decoder: JSONDecoder = .init()
        return try decoder.decode(T.self, from: data)
    }
    
    func smartFetch<T: Codable>(request: URLRequest, publisher: PassthroughSubject<T, Never>) async throws {
        do {
            try restoreCached(request: request, publisher: publisher)
        } catch {
            print(error.localizedDescription)
        }
        
        let remote: T = try await fetch(request: request)
        publisher.send(remote)
    }
    
    /// This is a broken function
    /// the function signiture should remain the same
    /// while the implementation should be working fine.
    /// What is expected? `Payload` should be cached properly
    /// And then It should be fully accessable via `smartfetch(_:,_:)` method
    func cacheFirstPostFetch<T: Codable>(
        request: URLRequest,
        payload: Data,
        publisher: PassthroughSubject<T, Never>
    ) async throws {
        let cache = URLCache.shared
        let urlResponse = HTTPURLResponse(
            url: request.url!,
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
        let cachedResponse: CachedURLResponse = .init(response: urlResponse, data: payload)
        cache.storeCachedResponse(cachedResponse, for: request)
        
        try await smartFetch(request: request, publisher: publisher)
    }
    
    private func restoreCached<T: Codable>(request: URLRequest, publisher: PassthroughSubject<T, Never>) throws {
        let cached: T = try load(request: request)
        publisher.send(cached)
    }
    
}

enum APIClientError: Error {
    case cannotLoadFromCache
}

extension Publisher {
    static func build<T>(for type: T.Type) -> PassthroughSubject<T, Never> {
        .init()
    }
}
