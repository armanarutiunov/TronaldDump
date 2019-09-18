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
        case titles = "_embedded"
    }
}
