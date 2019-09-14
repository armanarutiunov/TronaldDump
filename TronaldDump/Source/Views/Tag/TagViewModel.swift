//
//  TagViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol TagViewModel {
	var tagTitle: String { get }
}

public class ConcreteTagViewModel: TagViewModel {
	
	private let tagService: TagService
	
	public var tagTitle: String
	
	public init(tagService: TagService, tagTitle: String) {
		self.tagService = tagService
		self.tagTitle = tagTitle
	}
	
}
