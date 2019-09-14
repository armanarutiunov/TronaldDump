//
//  TagViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 13.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol TagViewModel {
	var title: String { get }
}

public class ConcreteTagViewModel: TagViewModel {
	
	private let tagService: TagService
	private let tag: Tag
	
	public var title: String {
		return tag.title
	}
	
	public init(tagService: TagService, tag: Tag) {
		self.tagService = tagService
		self.tag = tag
	}
	
}
