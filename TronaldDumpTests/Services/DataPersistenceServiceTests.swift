//
//  DataPersistenceServiceTests.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import XCTest
@testable import TronaldDump

class DataPersistenceServiceTests: XCTestCase {
	
	var systemUnderTest: DataPersistenceService!
	
	override func setUp() {
		systemUnderTest = ConcreteDataPersistenceService()
	}
	
	func test() {
		let dogs = [Dog(name: "Pecan", age: 3),
					Dog(name: "Walnut", age: 8)]
		systemUnderTest.setObject(dogs, for: "dogs")
		var savedDogs: [Dog]? {
			return systemUnderTest.getObject(type: [Dog].self, key: "dogs")
		}
		XCTAssertEqual(dogs, savedDogs)
		systemUnderTest.removeObject(for: "dogs")
		XCTAssertNotEqual(dogs, savedDogs)
	}
	
}

private struct Dog: Equatable, Codable {
	let name: String
	let age: Int
}
