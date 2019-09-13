//
//  CloudConfiguration.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public struct CloudConfiguration {
	public static let baseUrl = "https://api.tronalddump.io".forceUnwrappedUrl
	public static let header = ["accept": "application/hal+json"]
}
