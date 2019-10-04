//
//  CloudRequest.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public struct CloudRequest {
    
    let identifier: UUID
    let baseUrl: URL
    let route: String
    let httpMethod: HTTPMethod
    let parameters: [String: String]?
    let bodyData: Data?
    let httpHeader: [String: String]
    
    private var queryItems: [URLQueryItem]? {
        return parameters?.map { URLQueryItem(name: $0.key, value: $0.value) }
    }
    
    private var urlComponents: URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = baseUrl.scheme
        urlComponents.host = baseUrl.host
        urlComponents.path = route
        urlComponents.queryItems = queryItems
        return urlComponents
    }
    
    private var url: URL {
        guard let url = urlComponents.url else {
            fatalError("Failed to create CloudRequest url from path: \(route) and relative-Url: \(baseUrl.absoluteString)")
        }
        return url
    }
    
    public var urlRequest: URLRequest {
        var request = URLRequest(url: url, timeoutInterval: 10)
        request.httpBody = bodyData
        request.httpMethod = httpMethod.description
        request.allHTTPHeaderFields = httpHeader
        return request
    }
    
    public init(identifier: UUID = UUID(),
                baseUrl: URL = CloudConfiguration.baseUrl,
                route: String,
                httpMethod: HTTPMethod = .get,
                parameters: [String: String]? = nil,
                bodyData: Data? = nil,
                additionalHTTPHeader: [String: String] = CloudConfiguration.header) {
        self.identifier = identifier
        self.baseUrl = baseUrl
        self.route = route
        self.httpMethod = httpMethod
        self.parameters = parameters
        self.bodyData = bodyData
        self.httpHeader = additionalHTTPHeader
    }
}

extension CloudRequest: Equatable {
    public static func == (lhs: CloudRequest, rhs: CloudRequest) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension CloudRequest: CustomStringConvertible {
    public var description: String {
        return "cloud://\(route)"
    }
}
