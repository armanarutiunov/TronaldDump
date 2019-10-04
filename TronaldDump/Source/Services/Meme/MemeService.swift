//
//  MemeService.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import Foundation

public protocol MemeService {
    typealias MemeFetchCompletionBlock = (Result<Data, APIError>) -> Void
    
    func fetchRandomMeme(completion: @escaping MemeFetchCompletionBlock)
}

public class ConcreteMemeService: MemeService {
    
    private struct Endpoints {
        static let meme = "/random/meme"
    }
    
    private let cloudService: CloudService
    
    init(cloudService: CloudService) {
        self.cloudService = cloudService
    }
    
    public func fetchRandomMeme(completion: @escaping MemeFetchCompletionBlock) {
        let request = CloudRequest(route: Endpoints.meme,
                                   additionalHTTPHeader: ["accept": "image/jpeg"])
        cloudService.send(request) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                print("Cloud failure: \(error)")
                completion(.failure(.cloudFailure))
            }
        }
    }
}
