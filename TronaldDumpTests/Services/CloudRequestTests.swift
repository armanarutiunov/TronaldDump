//
//  CloudRequestTests.swift
//  TronaldDumpTests
//
//  Created by Arman Arutyunov on 17.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import XCTest
@testable import TronaldDump

class CloudRequestTests: XCTestCase {
	
	func testRequestUrl() {
		let request = CloudRequest(baseUrl: "https://dice.fm".forceUnwrappedUrl,
								   route: "jobs?shortcode=4321436002")
		XCTAssertEqual(request.url.string, "https://dice.fm/jobs?shortcode=4321436002")
	}

}
