//
//  DataPersistenceServiceMock.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation
@testable import TronaldDump

class DataPersistenceServiceMock: DataPersistenceService {
	private var dictionary = [String: Codable]()
	
	func setObject<Object>(_ object: Object, for key: String) where Object : Encodable {
		dictionary[key] = object as? Codable
	}
	
	func getObject<Object>(type: Object.Type, key: String) -> Object? where Object : Decodable {
		return dictionary[key] as? Object
	}
	
	func removeObject(for key: String) {
		dictionary.removeValue(forKey: key)
	}
}
