//
//  TagServiceMock.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation
@testable import TronaldDump

class TagServiceMock: TagService {
    
    var savedQuotes = [Quote]()
    
    func fetchTags(completion: @escaping FetchTagListCompletionBlock) {
        completion(.success(["Tag1", "Tag2"]))
    }
    
    func fetchQuotes(for tag: String, completion: @escaping FetchQuotesCompletionBlock) {
        let quotes = [Quote(id: "hufg8e934", value: "Quote1", urls: ["https://twitter.com".url])]
        completion(.success(quotes))
    }
    
    func searchQuotes(with query: String, completion: @escaping FetchQuotesCompletionBlock) {
        let quotes = [Quote(id: "hufg8e934", value: "Quote1", urls: ["https://twitter.com".url])]
        completion(.success(quotes))
    }
    
    func saveQuote(_ quote: Quote) {
        savedQuotes.append(quote)
    }
    
    func deleteQuote(_ quote: Quote) {
        if let index = savedQuotes.firstIndex(of: quote) {
            savedQuotes.remove(at: index)
        }
    }
    
    func isQuoteSaved(_ quote: Quote) -> Bool {
        return savedQuotes.contains(quote)
    }
    
}
