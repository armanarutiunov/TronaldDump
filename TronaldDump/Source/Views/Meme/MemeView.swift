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
	private let activityIndicator = UIActivityIndicatorView()
	
	private var memeImageViewHeightConstraint: NSLayoutConstraint?
	private var activityIndicatorYConstraint: NSLayoutConstraint?
	
	public var memeImage: UIImage {
		get {
			memeImageView.image ?? UIImage()
		}
		set {
			configureMemeImageViewHeight(with: newValue.size)
			memeImageView.image = newValue
		}
	}
	
	public var isImageLoading = false {
		didSet {
			isImageLoading ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
			activityIndicator.isHidden = !isImageLoading
			memeImageView.isHidden = isImageLoading
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
		addSubview(activityIndicator)
		
		subviews.forEach { $0.translatesAutoresizingMaskIntoConstraints = false }
			
		NSLayoutConstraint.activate([
			memeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			memeImageView.widthAnchor.constraint(equalTo: widthAnchor, constant: -2 * Constants.Label.margin.rawValue),
			
			activityIndicator.centerXAnchor.constraint(equalTo: memeImageView.centerXAnchor),
			
			updateMemeButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: Constants.Button.margin.rawValue),
			updateMemeButton.centerXAnchor.constraint(equalTo: centerXAnchor),
			updateMemeButton.heightAnchor.constraint(equalToConstant: 44)
		])
		
		activityIndicatorYConstraint = activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
		activityIndicatorYConstraint?.isActive = true
		
		if #available(iOS 11.0, *) {
			memeImageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: Constants.Label.margin.rawValue).isActive = true
			updateMemeButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -Constants.Button.margin.rawValue).isActive = true
		} else {
			memeImageView.topAnchor.constraint(equalTo: topAnchor, constant: Constants.Label.margin.rawValue).isActive = true
			updateMemeButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -Constants.Button.margin.rawValue).isActive = true
		}
    }
	
	private func configureSubviews() {
		configureTheme()
		memeImageView.contentMode = .scaleAspectFit
		updateMemeButton.addTarget(self, action: #selector(didTapUpdateMemeButtonAction), for: .touchUpInside)
	}
	
	private func configureTheme() {
		let isDarkMode: Bool
		if #available(iOS 12.0, *) {
			isDarkMode = traitCollection.userInterfaceStyle == .dark
		} else {
			isDarkMode = false
		}
		backgroundColor = isDarkMode ? .black : .white
		activityIndicator.color = isDarkMode ? .white : .gray
		updateMemeButton.backgroundColor = isDarkMode ? .white : .black
		updateMemeButton.setTitleColor(isDarkMode ? .black : .white, for: .normal)
	}
	
	@objc
	private func didTapUpdateMemeButtonAction() {
		didTapUpdateMemeButton?()
	}
	
	private func configureMemeImageViewHeight(with size: CGSize) {
		guard memeImageViewHeightConstraint == nil else {
			return
		}
		activityIndicatorYConstraint?.isActive = false
		
		memeImageViewHeightConstraint = memeImageView.heightAnchor.constraint(equalTo: memeImageView.widthAnchor, multiplier: size.height / size.width)
		memeImageViewHeightConstraint?.isActive = true
		
		activityIndicatorYConstraint = activityIndicator.centerYAnchor.constraint(equalTo: memeImageView.centerYAnchor)
		activityIndicatorYConstraint?.isActive = true
		
		layoutIfNeeded()
	}
}
