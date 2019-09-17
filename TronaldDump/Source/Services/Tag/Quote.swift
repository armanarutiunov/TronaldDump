//
//  Quote.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

protocol QuoteResponse: Decodable {
	var quotes: [Quote] { get }
}

enum QuoteResponseCodingKeys: String, CodingKey {
	case embedded = "_embedded"
	case quotes
	case tags
}

struct QuoteListResponse: QuoteResponse {
	let quotes: [Quote]
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: QuoteResponseCodingKeys.self)
			.nestedContainer(keyedBy: QuoteResponseCodingKeys.self, forKey: .embedded)
		quotes = try container.decode([Quote].self, forKey: .tags)
	}
}

struct QuoteSearchResponse: QuoteResponse {
	let quotes: [Quote]
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: QuoteResponseCodingKeys.self)
			.nestedContainer(keyedBy: QuoteResponseCodingKeys.self, forKey: .embedded)
		quotes = try container.decode([Quote].self, forKey: .quotes)
	}
}

public struct Quote: Codable {
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
	
	enum EncodingError: Error {
		case sourcesEncodingFailure
	}
	
	public init(id: String, value: String, urls: [URL?]) {
		self.id = id
		self.value = value
		self.urls = urls
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		id = try container.decode(String.self, forKey: .id)
		value = try container.decode(String.self, forKey: .value)
		
		let embeddedContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .embedded)
		let sources = try embeddedContainer.decode([Source].self, forKey: .sources)
		urls = sources.map { $0.urlString.url }
	}
	
	public func encode(to encoder: Encoder) throws {
		var container = encoder.container(keyedBy: CodingKeys.self)
		try container.encode(id, forKey: .id)
		try container.encode(value, forKey: .value)
		
		let sources = try urls.map { url -> Source in
			guard let urlString = url?.string else {
				throw EncodingError.sourcesEncodingFailure
			}
			return Source(urlString: urlString)
		}
		
		var embeddedContainer = container.nestedContainer(keyedBy: CodingKeys.self, forKey: .embedded)
		try embeddedContainer.encode(sources, forKey: .sources)
	}
}

struct Source: Codable {
    let urlString: String
	
	enum CodingKeys: String, CodingKey {
		case urlString = "url"
	}
}

extension Quote: Equatable {}
