//
//  Quote.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

struct QuoteListResponse: Decodable {
	let quotes: [Quote]
	
	enum CodingKeys: String, CodingKey {
		case embedded = "_embedded"
		case quotes = "tags"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
			.nestedContainer(keyedBy: CodingKeys.self, forKey: .embedded)
		quotes = try container.decode([Quote].self, forKey: .quotes)
	}
}

public struct Quote: Decodable {
	let id: String
	let value: String
	let urls: [URL?]

    enum CodingKeys: String, CodingKey {
        case id = "quote_id"
        case value
        case embedded = "_embedded"
		case sources = "source"
		case urls = "url"
    }
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		value = try container.decode(String.self, forKey: .value)
		
		let embeddedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .embedded)
		let sources = try embeddedContainer.decode([Source].self, forKey: .sources)
		urls = sources.map { $0.urlString.url }
	}
}

struct Source: Decodable {
    let urlString: String
	
	enum CodingKeys: String, CodingKey {
		case urlString = "url"
	}
}

extension Quote: Equatable {}
