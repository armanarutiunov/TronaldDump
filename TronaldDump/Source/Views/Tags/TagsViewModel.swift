//
//  TagsViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

protocol TagsViewModel {
	var tags: [Tag] { get }
}

public class ConcreteTagsViewModel: TagsViewModel {
	
	let tags = [Tag(title: "Donald Trump")]
	
	public init() {
		
	}
}
