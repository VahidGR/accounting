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
            let cached: T = try load(request: request)
            publisher.send(cached)
        } catch {
            print(error.localizedDescription)
        }
        
        let remote: T = try await fetch(request: request)
        publisher.send(remote)
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
