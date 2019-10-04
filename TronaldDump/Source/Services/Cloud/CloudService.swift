//
//  CloudService.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 12.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation


public protocol CloudService {
    typealias CloudRequestCompletionBlock = (Result<Data, Error>) -> Void
    func send(_ request: CloudRequest, completion: @escaping CloudRequestCompletionBlock)
}

public class ConcreteCloudService: CloudService {
    
    private let session = URLSession(configuration: .default)
    
    public func send(_ request: CloudRequest, completion: @escaping CloudRequestCompletionBlock) {
        session.dataTask(with: request.urlRequest) { (data, _, error) in
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
