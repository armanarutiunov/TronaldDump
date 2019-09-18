//
//  TagListViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol TagListViewModelObserver: AnyObject {
    func didFetchTags()
}

public protocol TagListViewModel {
    var tagTitles: [String] { get }
    
    func selectTag(at index: Int)
    
    func addObserver(_ observer: TagListViewModelObserver)
    func removeObserver(_ observer: TagListViewModelObserver)
}

public class ConcreteTagListViewModel: TagListViewModel {
    
    private let tagService: TagService
    private var observers = NSHashTable<AnyObject>.weakObjects()
    
    public var selectTagCommand: ((String) -> Void)?
    
    public var tagTitles = [String]() {
        didSet {
            notifyObserversTagsFetched()
        }
    }
    
    public init(tagService: TagService) {
        self.tagService = tagService
        fetchTags()
    }
    
    public func selectTag(at index: Int) {
        let tagTitle = tagTitles[index]
        selectTagCommand?(tagTitle)
    }
    
    public func addObserver(_ observer: TagListViewModelObserver) {
        observers.add(observer)
    }
    
    public func removeObserver(_ observer: TagListViewModelObserver) {
        observers.remove(observer)
    }
    
    // MARK: - Private
    
    private func fetchTags() {
        tagService.fetchTags { [weak self] result in
            switch result {
            case .success(let tagTitles):
                self?.tagTitles = tagTitles
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
    
    private func notifyObserversTagsFetched() {
        observers
            .allObjects
            .compactMap { $0 as? TagListViewModelObserver }
            .forEach { $0.didFetchTags() }
    }
}
