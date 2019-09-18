//
//  URLConvertibleTests.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import XCTest
@testable import TronaldDump

class URLConvertibleTests: XCTestCase {
    
    func testUrl() {
        let urlString = "https://dice.fm"
        let url = urlString.url
        XCTAssertEqual(url?.absoluteString, urlString)
        XCTAssertEqual(url?.string, urlString)
        XCTAssertEqual(url?.absoluteString, url?.string)
        XCTAssertNotNil(url?.forceUnwrappedUrl)
    }
    
}
