//
//  TagsViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol TagViewModelObserver: AnyObject {
	func didFetchTags()
}

public protocol TagsViewModel {
	var tags: [Tag] { get }
	
	func addObserver(_ observer: TagViewModelObserver)
	func removeObserver(_ observer: TagViewModelObserver)
}

public class ConcreteTagsViewModel: TagsViewModel {
	
	private let tagService: TagService
	private var observers = NSHashTable<AnyObject>.weakObjects()
	
	public var tags = [Tag]() {
		didSet {
			notifyObserversTagsFetched()
		}
	}
	
	public init(tagService: TagService) {
		self.tagService = tagService
		fetchTags()
	}
	
	public func addObserver(_ observer: TagViewModelObserver) {
		observers.add(observer)
	}
	
	public func removeObserver(_ observer: TagViewModelObserver) {
		observers.remove(observer)
	}
	
	// MARK: - Private
	
	private func fetchTags() {
		tagService.fetchTags { [weak self] result in
			switch result {
			case .success(let tags):
				self?.tags = tags
			case .failure(let error):
				print("Failure: \(error)")
			}
		}
	}
	
	private func notifyObserversTagsFetched() {
		observers
			.allObjects
			.compactMap { $0 as? TagViewModelObserver }
			.forEach { $0.didFetchTags() }
	}
}
