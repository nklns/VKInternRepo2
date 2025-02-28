import UIKit

protocol ReviewsViewDelegate: AnyObject {
	func didUseRefreshControl()
}

final class ReviewsView: UIView {

	private let refreshControl = UIRefreshControl()
	let activityIndicatorView = UIActivityIndicatorView()
	
    let tableView = UITableView()
	let footerLabel = UILabel()
	
	weak var delegate: ReviewsViewDelegate?

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = bounds.inset(by: safeAreaInsets)
    }

}

// MARK: - Internal

extension ReviewsView {
	
	func updateCountOfReviews(_ count: Int) {
		footerLabel.text = "\(count) отзывов"
	}
}

// MARK: - Private

private extension ReviewsView {

    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
		setupFooterLabel()
		setupRefreshControl()
		setupActivityIndicatorView()
		setupConstraints()
    }

	func setupActivityIndicatorView() {
		addSubview(activityIndicatorView)
		activityIndicatorView.color = .label
		activityIndicatorView.style = .large
		activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false

	}
	
	func setupRefreshControl() {
		tableView.refreshControl = refreshControl
		refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
	}
	
    func setupTableView() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100
    }
	
	func setupFooterLabel() {
		footerLabel.textAlignment = .center
		footerLabel.font = .reviewCount
		footerLabel.textColor = .reviewCount
		footerLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
		
		tableView.tableFooterView = footerLabel
	}

}

// MARK: - Layout

private extension ReviewsView {
	
	func setupConstraints() {
		// ActivityIndicator
		NSLayoutConstraint.activate([
			activityIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
			activityIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
		])
	}
	
}

// MARK: - Actions

private extension ReviewsView {
	
	@objc
	func refreshData() {
		delegate?.didUseRefreshControl()
		refreshControl.endRefreshing()
	}
	
}
