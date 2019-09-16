//
//  MemeView.swift
//  TronaldDump
//
//  Created by Arman Arutyunov on 15.09.2019.
//  Copyright © 2019 Arman Arutyunov. All rights reserved.
//

import UIKit

class MemeView: UIView {

	private struct Constants {
		enum Label: CGFloat {
			case margin = 20
		}
		enum Button: CGFloat {
			case margin = 20
			case side = 44
		}
	}
	
	private let memeImageView = UIImageView()
	private let updateMemeButton = UIButton()
	
	
	private var memeImageViewHeightConstraint: NSLayoutConstraint?
	
	public var memeImage: UIImage {
		get {
			memeImageView.image ?? UIImage()
		}
		set {
			configureMemeImageViewHeight(with: newValue.size)
			memeImageView.image = newValue
		}
	}
	
	public var updateMemeButtonTitle: String {
		get {
			updateMemeButton.title(for: .normal) ?? ""
		}
		set {
			updateMemeButton.setTitle(newValue, for: .normal)
		}
	}
	
	public var didTapUpdateMemeButton: (() -> Void)?
	
	init() {
        super.init(frame: CGRect.zero)
        addSubviewsAndConstraints()
		configureSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
	
	// MARK: - Private
	
	private func addSubviewsAndConstraints() {
        addSubview(memeImageView)
		addSubview(updateMemeButton)
		
		subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
			
		if #available(iOS 11.0, *) {
			NSLayoutConstraint.activate([
				memeImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Label.margin.rawValue),
				memeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
				memeImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * Constants.Label.margin.rawValue),
				
				updateMemeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Button.margin.rawValue),
				updateMemeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
				updateMemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Button.margin.rawValue),
				updateMemeButton.heightAnchor.constraint(equalToConstant: 44)
			])
		} else {
			// Fallback on earlier versions
		}
    }
	
	private func configureSubviews() {
		backgroundColor = .white
		memeImageView.contentMode = .scaleAspectFit
		
		updateMemeButton.backgroundColor = .black
		updateMemeButton.setTitleColor(.white, for: .normal)
		updateMemeButton.addTarget(self, action: #selector(didTapUpdateMemeButtonAction), for: .touchUpInside)
	}
	
	@objc
	private func didTapUpdateMemeButtonAction() {
		didTapUpdateMemeButton?()
	}
	
	private func configureMemeImageViewHeight(with size: CGSize) {
		guard memeImageViewHeightConstraint == nil else {
			return
		}
		memeImageViewHeightConstraint = memeImageView.heightAnchor.constraint(equalTo: memeImageView.widthAnchor, multiplier: size.height / size.width)
		memeImageViewHeightConstraint?.isActive = true
		layoutIfNeeded()
	}
}
