//
//  HTTPMethod.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public enum HTTPMethod {
    case get
    case post
    case put
    case delete
}

extension HTTPMethod: CustomStringConvertible {
    public var description: String {
        switch self {
        case .get:
            return "GET"
        case .post:
            return "POST"
        case .put:
            return "PUT"
        case .delete:
            return "DELETE"
        }
    }
}

extension HTTPMethod: Equatable {
    public static func == (lhs: HTTPMethod, rhs: HTTPMethod) -> Bool {
        switch (lhs, rhs) {
        case (.get, .get),
             (.post, .post),
             (.put, .put),
             (.delete, .delete):
            return true
        default:
            return false
        }
    }
}
