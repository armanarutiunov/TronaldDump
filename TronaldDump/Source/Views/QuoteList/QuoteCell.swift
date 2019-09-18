//
//  QuoteCell.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class QuoteCell: UITableViewCell {
    
    private struct Constants {
        enum Label: CGFloat {
            case margin = 15
        }
        
        enum Icon: CGFloat {
            case margin = 15
            case side = 25
        }
        
        enum Button: CGFloat {
            case side = 44
        }
    }
    
    private let quoteLabel = UILabel()
    private let saveButton = UIButton()
    private let bookmarkImageView = UIImageView()
    private var bookmarkIcon: UIImage? {
        return isBookmarked ? UIImage(named: "bookmark-full") : UIImage(named: "bookmark-empty")
    }
    
    var didUpdateSavedState: (() -> Void)?
    
    var isBookmarked = false {
        didSet {
            bookmarkImageView.image = bookmarkIcon
        }
    }
    
    var quoteText: String {
        get {
            quoteLabel.text ?? ""
        }
        set {
            quoteLabel.text = newValue
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubviewsAndConstraints()
        configureSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private
    
    private func addSubviewsAndConstraints() {
        contentView.addSubview(quoteLabel)
        contentView.addSubview(bookmarkImageView)
        contentView.addSubview(saveButton)
        
        contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
        
        NSLayoutConstraint.activate([
            quoteLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Label.margin.rawValue),
            quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Label.margin.rawValue),
            quoteLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -Constants.Label.margin.rawValue),
            quoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Label.margin.rawValue),
            
            bookmarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Icon.margin.rawValue),
            bookmarkImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Icon.margin.rawValue),
            bookmarkImageView.heightAnchor.constraint(equalToConstant: Constants.Icon.side.rawValue),
            bookmarkImageView.widthAnchor.constraint(equalToConstant: Constants.Icon.side.rawValue),
            
            saveButton.topAnchor.constraint(equalTo: contentView.topAnchor),
            saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            saveButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            saveButton.widthAnchor.constraint(equalToConstant: Constants.Button.side.rawValue)
        ])
    }
    
    private func configureSubviews() {
        quoteLabel.numberOfLines = 0
        bookmarkImageView.contentMode = .scaleAspectFit
        saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    }
    
    @objc
    private func didTapSaveButton() {
        didUpdateSavedState?()
    }
}
