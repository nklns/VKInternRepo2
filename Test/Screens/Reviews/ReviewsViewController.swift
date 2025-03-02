import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel

    init(viewModel: ReviewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = reviewsView
        title = "Отзывы"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
		setupBindings()
		fetchData()
    }

}

// MARK: - Private

private extension ReviewsViewController {
	
	func setupBindings() {
		setupViewModelBindings()
		setupImageTapHandler()
	}
	
	func fetchData() {
		viewModel.getReviews()
		RatingRenderer.shared.preloadCache()
	}

	func setupViewModelBindings() {
		viewModel.onStateChange = { [weak reviewsView] state in
			DispatchQueue.main.async {
				reviewsView?.tableView.reloadData()
				reviewsView?.updateCountOfReviews(state.items.count)
				state.isLoading ? reviewsView?.activityIndicatorView.startAnimating() : reviewsView?.activityIndicatorView.stopAnimating()
			}
		}
	}
	
	func setupImageTapHandler() {
		viewModel.didTapImage = { image in
			self.navigationController?.pushViewController(ImageViewController(reviewImage: image), animated: true)
		}
	}
	
	func makeReviewsView() -> ReviewsView {
		let reviewsView = ReviewsView()
		reviewsView.tableView.delegate = viewModel
		reviewsView.tableView.dataSource = viewModel
		reviewsView.delegate = self
		return reviewsView
	}

}

// MARK: - ReviewsViewDelegate

extension ReviewsViewController: ReviewsViewDelegate {
	
	func didUseRefreshControl() {
		viewModel.getReviews()
	}
	
}
