import UIKit

final class ReviewsViewController: UIViewController {

    private lazy var reviewsView = makeReviewsView()
    private let viewModel: ReviewsViewModel
	private let refreshControl = UIRefreshControl()

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
		setupRefreshControl()
    }

}

// MARK: - Private

private extension ReviewsViewController {

    func makeReviewsView() -> ReviewsView {
        let reviewsView = ReviewsView()
        reviewsView.tableView.delegate = viewModel
        reviewsView.tableView.dataSource = viewModel
		reviewsView.tableView.refreshControl = refreshControl
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
	
	func setupRefreshControl() {
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}

}

// MARK: - Actions

private extension ReviewsViewController {
	
	@objc
	func refreshData() {
		viewModel.getReviews()
		reviewsView.tableView.refreshControl?.endRefreshing()
	}
	
}

// MARK: - ReviewCellDelegate

extension ReviewsViewController: ReviewCellDelegate {
	
	func showMoreButtonTapped(config: ReviewCellConfig) {
		config.onTapShowMore(config.id)
	}
	
}
