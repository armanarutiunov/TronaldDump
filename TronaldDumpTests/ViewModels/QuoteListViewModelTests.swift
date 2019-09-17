//
//  QuoteListViewModelTests.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import XCTest
@testable import TronaldDump

class QuoteListViewModelTests: XCTestCase {

	var tagServiceMock: TagService!
	var systemUnderTest: QuoteListViewModel!
	
    override func setUp() {
		tagServiceMock = TagServiceMock()
        systemUnderTest = ConcreteQuoteListViewModel(tagService: tagServiceMock, tagTitle: "", isSearchEnabled: false)
    }
	
	func testQuotesFetchedOnInit() {
		let exp = expectation(description: "callback handle")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			XCTAssertEqual(self?.systemUnderTest.quotes.count, 1)
			exp.fulfill()
		}
		waitForExpectations(timeout: 0.1, handler: nil)
	}

	func testQuotesNotFetchedOnInit() {
		let exp = expectation(description: "callback handle")
		systemUnderTest = ConcreteQuoteListViewModel(tagService: tagServiceMock, tagTitle: "", isSearchEnabled: true)
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			XCTAssertEqual(self?.systemUnderTest.quotes.count, 0)
			exp.fulfill()
		}
		waitForExpectations(timeout: 0.1, handler: nil)
	}
	
	func testSourceUrlProvider() {
		let exp = expectation(description: "callback handle")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			let url = self?.systemUnderTest.sourceUrl(at: 0)
			XCTAssertEqual(url, "https://twitter.com".url)
			exp.fulfill()
		}
		waitForExpectations(timeout: 0.1, handler: nil)
	}
	
	func testQuoteBookmarking() {
		let exp = expectation(description: "callback handle")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			guard let self = self else {
				return
			}
			XCTAssertFalse(self.systemUnderTest.isQuoteSaved(at: 0))
			self.systemUnderTest.updateQuoteState(at: 0)
			XCTAssertTrue(self.systemUnderTest.isQuoteSaved(at: 0))
			self.systemUnderTest.updateQuoteState(at: 0)
			XCTAssertFalse(self.systemUnderTest.isQuoteSaved(at: 0))
			exp.fulfill()
		}
		waitForExpectations(timeout: 0.1, handler: nil)
	}
	
	func testSearch() {
		let exp = expectation(description: "callback handle")
		systemUnderTest = ConcreteQuoteListViewModel(tagService: tagServiceMock, tagTitle: "", isSearchEnabled: true)
		systemUnderTest.searchQuotes(with: "")
		XCTAssertEqual(systemUnderTest.quotes.count, 0)
		systemUnderTest.searchQuotes(with: "123")
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
			XCTAssertEqual(self?.systemUnderTest.quotes.count, 1)
			exp.fulfill()
		}
		waitForExpectations(timeout: 0.1, handler: nil)
	}
}
