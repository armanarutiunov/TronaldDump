//
//  CloudService.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public typealias CloudRequestCompletionBlock = (Result<Data, Error>) -> Void

public protocol CloudService {
	func send(_ request: CloudRequest, completion: @escaping CloudRequestCompletionBlock)
}

public class ConcreteCloudService: CloudService {
	
	private let session = URLSession(configuration: .default)
	
	public func send(_ request: CloudRequest, completion: @escaping CloudRequestCompletionBlock) {
		session.dataTask(with: request.url) { (data, _, error) in
			DispatchQueue.main.async {
				if let data = data {
					completion(.success(data))
				} else if let error = error {
					completion(.failure(error))
				}
			}
		}.resume()
	}
}
