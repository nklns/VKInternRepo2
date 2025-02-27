import UIKit

final class ReviewsView: UIView {

    let tableView = UITableView()
	let footerLabel = UILabel()

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

// MARK: - Private

private extension ReviewsView {

    func setupView() {
        backgroundColor = .systemBackground
        setupTableView()
		setupFooterLabel()
    }

    func setupTableView() {
        addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.register(ReviewCell.self, forCellReuseIdentifier: ReviewCellConfig.reuseId)
		tableView.rowHeight = UITableView.automaticDimension
		tableView.estimatedRowHeight = 100
		
		tableView.tableFooterView = footerLabel
    }
	
	func setupFooterLabel() {
		footerLabel.text = "0 отзывов"
		footerLabel.textAlignment = .center
		footerLabel.font = .reviewCount
		footerLabel.textColor = .reviewCount
		footerLabel.frame = CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 40)
	}

}

// MARK: - Internal

extension ReviewsView {
	
	func updateCountOfReviews(_ count: Int) {
		footerLabel.text = "\(count) отзывов"
	}
	
}
