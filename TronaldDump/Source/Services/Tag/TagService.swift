//
//  TagService.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public enum TagFetchError: Error {
	case cloudFailure
	case decodeFailure
}

public protocol TagService {
	typealias FetchTagCompletionBlock = (Result<[String], TagFetchError>) -> Void
	func fetchTags(completion: @escaping FetchTagCompletionBlock)
}

public class ConcreteTagService: TagService {
	
	private struct Endpoints {
		static let tag = "tag"
	}
	
	private let cloudService: CloudService
	
	init(cloudService: CloudService) {
		self.cloudService = cloudService
	}
	
	public func fetchTags(completion: @escaping FetchTagCompletionBlock) {
		let request = CloudRequest(route: Endpoints.tag)
		cloudService.send(request) { [weak self] result in
			guard let self = self else {
				return
			}
			switch result {
			case .success(let data):
				guard let tagTitles = self.decodeData(data) else {
					completion(.failure(.decodeFailure))
					return
				}
				completion(.success(tagTitles))
			case .failure(let error):
				print("Cloud failure: \(error)")
				completion(.failure(.cloudFailure))
			}
		}
	}
	
	// MARK: - Private
	
	private func decodeData(_ data: Data) -> [String]? {
		do {
			let tagList = try JSONDecoder().decode(TagList.self, from: data)
			return tagList.titles
		} catch {
			print("Failed to decode data: \n\(String(describing: String(data: data, encoding: .utf8))). \nError: \(error)")
		}
		return nil
	}
}
