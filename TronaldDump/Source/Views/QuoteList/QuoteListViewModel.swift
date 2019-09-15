//
//  QuoteListViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol QuoteListViewModelObserver: AnyObject {
	func didFetchQuotes()
}

public protocol QuoteListViewModel {
	var tagTitle: String { get }
	var quotes: [Quote] { get }
	
	func sourceUrl(at index: Int) -> URL? 
	func addObserver(_ observer: QuoteListViewModelObserver)
	func removeObserver(_ observer: QuoteListViewModelObserver)
}

public class ConcreteQuoteListViewModel: QuoteListViewModel {
	
	private let tagService: TagService
	private var observers = NSHashTable<AnyObject>.weakObjects()
	
	public var tagTitle: String
	public var quotes = [Quote]() {
		didSet {
			notifyObserversQuotesFetched()
		}
	}
	
	public init(tagService: TagService, tagTitle: String) {
		self.tagService = tagService
		self.tagTitle = tagTitle
		fetchQuotes()
	}
	
	public func sourceUrl(at index: Int) -> URL? {
		guard let url = quotes[index].urls.first(where: { $0 != nil }), let safeUrl = url else {
			return nil
		}
		return safeUrl
	}
	
	public func addObserver(_ observer: QuoteListViewModelObserver) {
		observers.add(observer)
	}
	
	public func removeObserver(_ observer: QuoteListViewModelObserver) {
		observers.remove(observer)
	}
	
	// MARK: - Private
	
	private func fetchQuotes() {
		tagService.fetchQuotes(for: tagTitle) { [weak self] result in
			switch result {
			case .success(let quotes):
				self?.quotes = quotes
			case .failure(let error):
				print("Failure: \(error)")
			}
		}
	}
	
	private func notifyObserversQuotesFetched() {
		observers
			.allObjects
			.compactMap { $0 as? QuoteListViewModelObserver }
			.forEach { $0.didFetchQuotes() }
	}
}
