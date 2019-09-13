//
//  URLExtensions.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

/// Either a String representing URL or a URL itself
public protocol URLConvertible {
    var string: String { get }
    var url: URL? { get }
}

public extension URLConvertible {
    var forceUnwrappedUrl: URL {
		guard let url = url else {
			fatalError("Failed unwrapping url from string: \(string)")
		}
        return url
    }
}

extension String: URLConvertible {
    public var string: String {
        return self
    }

    public var url: URL? {
        return URL(string: self)
    }
}

extension URL: URLConvertible {
    public var string: String {
        return absoluteString
    }

    public var url: URL? {
        return self
    }
}
