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
		enum Button: CGFloat {
			case side = 44
		}
	}
	
	private let quoteLabel = UILabel()
	private let saveButton = UIButton()
	
	var didUpdateSavedState: (() -> Void)?
	
	var saveButtonIcon: UIImage? {
		get {
			return saveButton.image(for: .normal)
		} set {
			saveButton.setImage(newValue, for: .normal)
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
		contentView.addSubview(saveButton)
		
		contentView.subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
		
		NSLayoutConstraint.activate([
			quoteLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Constants.Label.margin.rawValue),
			quoteLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Constants.Label.margin.rawValue),
			quoteLabel.trailingAnchor.constraint(equalTo: saveButton.leadingAnchor, constant: -Constants.Label.margin.rawValue),
			quoteLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Constants.Label.margin.rawValue),
			
			saveButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Constants.Label.margin.rawValue),
			saveButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
			saveButton.heightAnchor.constraint(equalToConstant: Constants.Button.side.rawValue),
			saveButton.widthAnchor.constraint(equalToConstant: Constants.Button.side.rawValue)
		])
	}
	
	private func configureSubviews() {
		quoteLabel.numberOfLines = 0
		saveButton.setImage(saveButtonIcon, for: .normal)
		saveButton.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
	}
	
	@objc
	private func didTapSaveButton() {
		didUpdateSavedState?()
	}
}
