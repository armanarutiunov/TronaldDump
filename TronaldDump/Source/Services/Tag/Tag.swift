//
//  Tag.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public struct TagResponse: Decodable {
	let tags: [Tag]
	
	private enum CodingKeys: String, CodingKey {
		case tags = "_embedded"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		tags = try container
			.decode([String].self, forKey: .tags)
			.map { Tag(title: $0) }
	}
}

public struct Tag {
	let title: String
}
