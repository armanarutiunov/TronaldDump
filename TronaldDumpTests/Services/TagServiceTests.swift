//
//  TagServiceTests.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import XCTest
@testable import TronaldDump

class TagServiceTests: XCTestCase {

	var systemUnderTest: TagService!
	var cloudServiceMock: CloudService!
	
    override func setUp() {
		cloudServiceMock = CloudServiceMock()
        systemUnderTest = ConcreteTagService(cloudService: cloudServiceMock)
    }
	
	func testFetchTags() {
		let exp = expectation(description: "cloud request handle")
		systemUnderTest.fetchTags { result in
			guard case .success(let tags) = result else {
				XCTFail()
				return
			}
			XCTAssertTrue(!tags.isEmpty)
			exp.fulfill()
		}
		waitForExpectations(timeout: 0.5, handler: nil)
	}
	
	func testFetchQuotes() {
		let exp = expectation(description: "cloud request handle")
		systemUnderTest.fetchQuotes(for: "Hillary Clinton") { result in
			guard case .success(let quotes) = result else {
				XCTFail()
				return
			}
			XCTAssertTrue(!quotes.isEmpty)
			exp.fulfill()
		}
		waitForExpectations(timeout: 0.5, handler: nil)
	}

}
