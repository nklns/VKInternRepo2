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
        setupViewModel()
        viewModel.getReviews()
		RatingRenderer.shared.preloadCache()
    }

}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
		reviewsView.delegate = self
        return reviewsView
    }

    func setupViewModel() {
		viewModel.onStateChange = { [weak self, weak reviewsView] _ in
			DispatchQueue.main.async {
				reviewsView?.tableView.reloadData()
				reviewsView?.updateCountOfReviews(self?.viewModel.countOfItems ?? 0)
			}
        }
    }

}

// MARK: - ReviewsViewDelegate

extension ReviewsViewController: ReviewsViewDelegate {
	
	func didUseRefreshControl() {
		viewModel.getReviews()
	}
	
}
