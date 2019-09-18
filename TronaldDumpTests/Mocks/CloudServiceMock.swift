//
//  CloudServiceMock.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation
@testable import TronaldDump

enum JSONError: Error {
	case fileNotFound
}

class CloudServiceMock: CloudService {
	
	func send(_ request: CloudRequest, completion: @escaping CloudRequestCompletionBlock) {
		guard let path = Bundle(for: TronaldDumpTests.self).path(forResource: fileName(for: request.route), ofType: "json") else {
			return completion(.failure(JSONError.fileNotFound))
		}
		do {
			let jsonData = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
			completion(.success(jsonData))
		} catch {
			completion(.failure(error))
		}
	}
	
	private func fileName(for route: String) -> String {
		switch route {
		case "tag":
			return "tags"
		case "tag/Hillary Clinton":
			return "quotes"
		default:
			return ""
		}
	}
}
