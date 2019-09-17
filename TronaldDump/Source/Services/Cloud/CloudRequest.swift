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
    let bodyData: Data?
    let additionalHTTPHeader: [String: String]
	
	public var url: URL {
		guard let encodedRoute = route.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
			let url = URL(string: encodedRoute, relativeTo: baseUrl) else {
				fatalError("Failed to create CloudRequest url from path: \(route) and relative-Url: \(baseUrl.absoluteString)")
		}
		return url
	}
	
    public init(identifier: UUID = UUID(),
				baseUrl: URL = CloudConfiguration.baseUrl,
                route: String,
                httpMethod: HTTPMethod = .get,
                bodyData: Data? = nil,
                additionalHTTPHeader: [String: String] = CloudConfiguration.header) {
        self.identifier = identifier
		self.baseUrl = baseUrl
        self.route = route
        self.httpMethod = httpMethod
        self.bodyData = bodyData
		self.additionalHTTPHeader = additionalHTTPHeader
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
