//
//  TagViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol TagViewModelObserver: AnyObject {
	func didFetchQuotes()
}

public protocol TagViewModel {
	var tagTitle: String { get }
	var quotes: [Quote] { get }
	
	func addObserver(_ observer: TagViewModelObserver)
	func removeObserver(_ observer: TagViewModelObserver)
}

public class ConcreteTagViewModel: TagViewModel {
	
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
	
	public func addObserver(_ observer: TagViewModelObserver) {
		observers.add(observer)
	}
	
	public func removeObserver(_ observer: TagViewModelObserver) {
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
			.compactMap { $0 as? TagViewModelObserver }
			.forEach { $0.didFetchQuotes() }
	}
}
