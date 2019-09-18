//
//  TagService.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public enum APIError: Error {
	case cloudFailure
	case decodeFailure
}

public protocol TagService {
	typealias FetchTagListCompletionBlock = (Result<[String], APIError>) -> Void
	typealias FetchQuotesCompletionBlock = (Result<[Quote], APIError>) -> Void
	
	func fetchTags(completion: @escaping FetchTagListCompletionBlock)
	func fetchQuotes(for tag: String, completion: @escaping FetchQuotesCompletionBlock)
}

public class ConcreteTagService: TagService {
	
	private struct Endpoints {
		static let tag = "tag"
	}
	
	private let cloudService: CloudService
	
	init(cloudService: CloudService) {
		self.cloudService = cloudService
	}
	
	public func fetchTags(completion: @escaping FetchTagListCompletionBlock) {
		let request = CloudRequest(route: Endpoints.tag)
		cloudService.send(request) { [weak self] result in
			guard let self = self else {
				return
			}
			switch result {
			case .success(let data):
				guard let tagTitles = self.decodeTagList(from: data) else {
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
	
	public func fetchQuotes(for tag: String, completion: @escaping FetchQuotesCompletionBlock) {
		let request = CloudRequest(route: "\(Endpoints.tag)/\(tag)")
		cloudService.send(request) { [weak self] result in
			guard let self = self else {
				return
			}
			switch result {
			case .success(let data):
				guard let quotes = self.decodeQuoteList(from: data, isSearchData: false) else {
					completion(.failure(.decodeFailure))
					return
				}
				completion(.success(quotes))
			case .failure(let error):
				print("Cloud failure: \(error)")
				completion(.failure(.cloudFailure))
			}
		}
	}
	
	// MARK: - Private
	
	private func decodeTagList(from data: Data) -> [String]? {
		do {
			let tagList = try JSONDecoder().decode(TagList.self, from: data)
			return tagList.titles
		} catch {
			print("Failed to decode data: \n\(String(describing: String(data: data, encoding: .utf8))). \nError: \(error)")
		}
		return nil
	}
	
	private func decodeQuoteList(from data: Data, isSearchData: Bool) -> [Quote]? {
		do {
			let quoteResponse = try JSONDecoder().decode(QuoteListResponse.self, from: data)
			return quoteResponse.quotes
		} catch {
			print("Failed to decode data: \n\(String(describing: String(data: data, encoding: .utf8))). \nError: \(error)")
		}
		return nil
	}
}
