//
//  ImageView.swift
//  Test
//
//  Created by Станислав Никулин on 02.03.2025.
//

import UIKit

final class ImageView: UIView {
	
	private let reviewImageView = UIImageView()

	init(reviewImage: UIImage) {
		super.init(frame: .zero)
		self.reviewImageView.image = reviewImage
		setupView()
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
}

// MARK: - Private Methods

private extension ImageView {
	
	func setupView() {
		self.backgroundColor = .white
		
		setupReviewImageView()
		setupConstraints()
	}
	
	
	func setupReviewImageView() {
		addSubview(reviewImageView)
		reviewImageView.contentMode = .scaleToFill
		reviewImageView.translatesAutoresizingMaskIntoConstraints = false
		reviewImageView.layer.cornerRadius = 30
		reviewImageView.clipsToBounds = true
	}
	
	func setupConstraints() {
		NSLayoutConstraint.activate([
			reviewImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
			reviewImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
			reviewImageView.widthAnchor.constraint(equalToConstant: 400),
			reviewImageView.heightAnchor.constraint(equalToConstant: 400)
		  ])
	}
	
}
