//
//  TagList.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public struct TagList: Decodable {
	let titles: [String]
	
	private enum CodingKeys: String, CodingKey {
		case tagTitles = "_embedded"
	}
	
	public init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		titles = try container.decode([String].self, forKey: .tagTitles)
	}
}
