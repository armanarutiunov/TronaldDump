//
//  MemeViewModel.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

public protocol MemeViewModelObserver: AnyObject {
    func didUpdateMeme()
}

public protocol MemeViewModel {
    var image: UIImage { get }
    
    func updateMeme()
    func addObserver(_ observer: MemeViewModelObserver)
    func removeObserver(_ observer: MemeViewModelObserver)
}

public class ConcreteMemeViewModel: MemeViewModel {
    
    private let memeService: MemeService
    private var observers = NSHashTable<AnyObject>.weakObjects()
    
    public var image = UIImage() {
        didSet {
            notifyObserversMemeUpdated()
        }
    }
    
    init(memeService: MemeService) {
        self.memeService = memeService
    }
    
    public func updateMeme() {
        memeService.fetchRandomMeme { [weak self] result in
            switch result {
            case .success(let data):
                if let meme = UIImage(data: data) {
                    self?.image = meme
                }
            case .failure(let error):
                print("Failure: \(error)")
            }
        }
    }
    
    public func addObserver(_ observer: MemeViewModelObserver) {
        observers.add(observer)
    }
    
    public func removeObserver(_ observer: MemeViewModelObserver) {
        observers.remove(observer)
    }
    
    // MARK: - Private
    
    private func notifyObserversMemeUpdated() {
        observers
            .allObjects
            .compactMap { $0 as? MemeViewModelObserver }
            .forEach { $0.didUpdateMeme() }
    }
}
