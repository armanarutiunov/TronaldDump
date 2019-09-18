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
    var isSearchEnabled: Bool { get }
    
    func sourceUrl(at index: Int) -> URL?
    func isQuoteSaved(at index: Int) -> Bool
    func updateQuoteState(at index: Int)
    
    func searchQuotes(with query: String)
    
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
    
    public var isSearchEnabled: Bool
    
    public init(tagService: TagService, tagTitle: String, isSearchEnabled: Bool) {
        self.tagService = tagService
        self.tagTitle = tagTitle
        self.isSearchEnabled = isSearchEnabled
        if !isSearchEnabled {
            fetchQuotes()
        }
    }
    
    public func sourceUrl(at index: Int) -> URL? {
        guard let url = quotes[index].urls.first(where: { $0 != nil }), let safeUrl = url else {
            return nil
        }
        return safeUrl
    }
    
    public func isQuoteSaved(at index: Int) -> Bool {
        let quote = quotes[index]
        return tagService.isQuoteSaved(quote)
    }
    
    public func updateQuoteState(at index: Int) {
        let quote = quotes[index]
        if tagService.isQuoteSaved(quote) {
            tagService.deleteQuote(quote)
        } else {
            tagService.saveQuote(quote)
        }
    }
    
    public func searchQuotes(with query: String) {
        guard query.count >= 3 else {
            quotes = [Quote]()
            return
        }
        tagService.searchQuotes(with: query) { [weak self] result in
            switch result {
            case .success(let quotes):
                self?.quotes = quotes
            case .failure(let error):
                self?.quotes = [Quote]()
                print("Failure: \(error)")
            }
        }
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
