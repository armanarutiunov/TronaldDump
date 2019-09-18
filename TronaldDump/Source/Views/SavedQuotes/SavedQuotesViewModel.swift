//
//  SavedQuotesViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol SavedQuotesViewModel {
    var quotes: [Quote] { get }
    
    func sourceUrl(at index: Int) -> URL?
    func deleteQuote(at index: Int)
}

public class ConcreteSavedQuotesViewModel: SavedQuotesViewModel {
    
    private let tagService: TagService
    
    public var quotes: [Quote] {
        return tagService.savedQuotes
    }
    
    public init(tagService: TagService) {
        self.tagService = tagService
    }
    
    public func sourceUrl(at index: Int) -> URL? {
        guard let url = quotes[index].urls.first(where: { $0 != nil }), let safeUrl = url else {
            return nil
        }
        return safeUrl
    }
    
    public func deleteQuote(at index: Int) {
        let quote = quotes[index]
        tagService.deleteQuote(quote)
    }
}
