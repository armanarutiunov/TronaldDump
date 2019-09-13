//
//  ServiceContainer.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public struct ServiceContainer {
	
	lazy var cloudService: CloudService = {
		return ConcreteCloudService()
	}()
	
	lazy var tagService: TagService = {
		return ConcreteTagService(cloudService: cloudService)
	}()
	
}
