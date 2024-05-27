//
//  URLRequest+Init.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import Foundation

extension URLRequest {
}

extension URLRequest {
    static func get(
        _ route: APIRoute,
        parameters: [String: String]? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 6
    ) -> Self {
        var components = URLComponents(url: .init(route: route), resolvingAgainstBaseURL: false)!
        if let parameters {
            components.queryItems = parameters.compactMap({
                .init(
                    name: $0.key.lowercased(),
                    value: $0.value.lowercased()
                )
            })
        }
        print(components.url!)
        return .init(url: components.url!, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    static func post(
        _ route: APIRoute,
        payload: Data? = nil,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval = 6
    ) -> Self {
        var request: Self = .init(route, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        request.httpMethod = "POST"
        request.httpBody = payload
        print(request.url!)
        return request
    }
    
    init(
        _ route: APIRoute,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
        timeoutInterval: TimeInterval
    ) {
        let url: URL = .init(route: route)
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
}

extension URL {
    init(route: APIRoute) {
        self.init(string: "http://localhost:8080/\(route.components)")!
    }
}

enum APIRoute {
    case expenseList(category: String)
    
    var components: String {
        switch self {
        case .expenseList(let category):
            "expenses/\(category)"
        }
    }
}
