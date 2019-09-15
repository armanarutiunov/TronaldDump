//
//  DataPersistenceService.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol DataPersistenceService {
	func setObject<Object>(_ object: Object, for key: String) where Object : Encodable
	func getObject<Object>(type: Object.Type, key: String) -> Object? where Object : Decodable
	func removeObject(for key: String)
}

public class ConcreteDataPersistenceService: DataPersistenceService {
	
	let userDefaults = UserDefaults.standard
	
	public init() {
		
	}
	
	public func setObject<Object>(_ object: Object, for key: String) where Object : Encodable {
		do {
            let data = try JSONEncoder().encode(object)
			userDefaults.set(data, forKey: key)
        } catch {
            print("Failed to encode object of type \(type(of: object)) with error: \(error.localizedDescription)")
        }
	}
	
	public func getObject<Object>(type: Object.Type, key: String) -> Object? where Object : Decodable {
		guard let data = userDefaults.data(forKey: key),
            let object = try? JSONDecoder().decode(Object.self, from: data) else {
            return nil
        }
        return object
	}
	
	public func removeObject(for key: String) {
		userDefaults.removeObject(forKey: key)
	}
}
