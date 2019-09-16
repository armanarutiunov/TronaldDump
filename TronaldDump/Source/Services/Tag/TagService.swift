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
	
	var savedQuotes: [Quote] { get }
	
	func fetchTags(completion: @escaping FetchTagListCompletionBlock)
	func fetchQuotes(for tag: String, completion: @escaping FetchQuotesCompletionBlock)
	func saveQuote(_ quote: Quote)
	func deleteQuote(_ quote: Quote)
	func isQuoteSaved(_ quote: Quote) -> Bool
}

public class ConcreteTagService: TagService {
	
	private struct Endpoints {
		static let tag = "tag"
	}
	
	private struct Constants {
		static let savedQuotesKey = "saved_quotes"
	}
	
	private let cloudService: CloudService
	private let dataPersistenceService: DataPersistenceService
	
	public var savedQuotes: [Quote] {
		get {
			return dataPersistenceService.getObject(type: [Quote].self, key: Constants.savedQuotesKey) ?? [Quote]()
		}
		set {
			dataPersistenceService.setObject(newValue, for: Constants.savedQuotesKey)
		}
	}
	
	
	init(cloudService: CloudService, dataPersistenceService: DataPersistenceService) {
		self.cloudService = cloudService
		self.dataPersistenceService = dataPersistenceService
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
				guard let quotes = self.decodeQuoteList(from: data) else {
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
	
	public func saveQuote(_ quote: Quote) {
		savedQuotes.append(quote)
	}
	
	public func deleteQuote(_ quote: Quote) {
		if let index = savedQuotes.firstIndex(of: quote) {
			savedQuotes.remove(at: index)
		}
	}
	
	public func isQuoteSaved(_ quote: Quote) -> Bool {
		return savedQuotes.contains(quote)
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
	
	private func decodeQuoteList(from data: Data) -> [Quote]? {
		do {
			let quoteListResponse = try JSONDecoder().decode(QuoteListResponse.self, from: data)
			return quoteListResponse.quotes
		} catch {
			print("Failed to decode data: \n\(String(describing: String(data: data, encoding: .utf8))). \nError: \(error)")
		}
		return nil
	}
}
