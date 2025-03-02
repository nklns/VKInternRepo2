//
//  ImageViewController.swift
//  Test
//
//  Created by Станислав Никулин on 02.03.2025.
//

import UIKit

final class ImageViewController: UIViewController {
	
	private lazy var imageView = ImageView(reviewImage: reviewImage)
	private let reviewImage: UIImage
	
	init(reviewImage: UIImage) {
		self.reviewImage = reviewImage
		super.init(nibName: nil, bundle: nil)
	}
	
	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	override func loadView() {
		view = imageView
	}
	
}

