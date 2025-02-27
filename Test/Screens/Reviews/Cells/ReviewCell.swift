import UIKit

/// Конфигурация ячейки. Содержит данные для отображения в ячейке.
struct ReviewCellConfig {

    /// Идентификатор для переиспользования ячейки.
    static let reuseId = String(describing: ReviewCellConfig.self)

    /// Идентификатор конфигурации. Можно использовать для поиска конфигурации в массиве.
    let id = UUID()
	/// Имя и Фамилия разделенные 1 пробелом.
	let fullName: NSAttributedString
	/// Рейтинг отзыва.
	let rating: Int
	/// Текст отзыва.
    let reviewText: NSAttributedString
    /// Максимальное отображаемое количество строк текста. По умолчанию 3.
    var maxLines = 3
    /// Время создания отзыва.
    let created: NSAttributedString
    /// Замыкание, вызываемое при нажатии на кнопку "Показать полностью...".
    let onTapShowMore: (UUID) -> Void

}

// MARK: - TableCellConfig

extension ReviewCellConfig: TableCellConfig {

    /// Метод обновления ячейки.
    /// Вызывается из `cellForRowAt:` у `dataSource` таблицы.
    func update(cell: UITableViewCell) {
        guard let cell = cell as? ReviewCell else { return }
		cell.fullNameLabel.attributedText = fullName
        cell.reviewTextLabel.attributedText = reviewText
        cell.reviewTextLabel.numberOfLines = maxLines
        cell.createdLabel.attributedText = created
		
		cell.ratingImageView.image = RatingRenderer().ratingImage(rating)
		
        cell.config = self
    }

}

// MARK: - Private

private extension ReviewCellConfig {

    /// Текст кнопки "Показать полностью...".
    static let showMoreText = "Показать полностью..."
        .attributed(font: .showMore, color: .showMore)

}

// MARK: - Cell

final class ReviewCell: UITableViewCell {

	fileprivate var config: Config?
	
	fileprivate let fullNameLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.lineBreakMode = .byTruncatingTail
		return label
	}()
	
	fileprivate let reviewTextLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		label.lineBreakMode = .byWordWrapping
		return label
	}()
	
	fileprivate let createdLabel: UILabel = {
		let label = UILabel()
		label.translatesAutoresizingMaskIntoConstraints = false
		return label
	}()
	
	fileprivate let showMoreButton: UIButton = {
		let button = UIButton()
		button.translatesAutoresizingMaskIntoConstraints = false
		button.contentVerticalAlignment = .fill
		button.setAttributedTitle(Config.showMoreText, for: .normal)
		return button
	}()
	
	fileprivate let avatarImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		imageView.contentMode = .scaleAspectFill
		imageView.clipsToBounds = true
		imageView.layer.cornerRadius = 18
		imageView.image = UIImage(named: "l5w5aIHioYc")
		return imageView
	}()
	
	fileprivate let ratingImageView: UIImageView = {
		let imageView = UIImageView()
		imageView.translatesAutoresizingMaskIntoConstraints = false
		return imageView
	}()

	// MARK: - Init

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCell()
	}
}

// MARK: - Private Setup

private extension ReviewCell {

	func setupCell() {
		contentView.addSubview(avatarImageView)
		contentView.addSubview(fullNameLabel)
		contentView.addSubview(ratingImageView)
		contentView.addSubview(reviewTextLabel)
		contentView.addSubview(showMoreButton)
		contentView.addSubview(createdLabel)
		
		NSLayoutConstraint.activate([
			
			// Аватар
			avatarImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 9),
			avatarImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
			avatarImageView.widthAnchor.constraint(equalToConstant: 36),
			avatarImageView.heightAnchor.constraint(equalToConstant: 36),
			
			// Имя
			fullNameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor),
			fullNameLabel.leadingAnchor.constraint(equalTo: avatarImageView.trailingAnchor, constant: 10),
			fullNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -12),
			
			// Рейтинг
			ratingImageView.topAnchor.constraint(equalTo: fullNameLabel.bottomAnchor, constant: 6),
			ratingImageView.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
			ratingImageView.widthAnchor.constraint(equalToConstant: 84),
			ratingImageView.heightAnchor.constraint(equalToConstant: 16),
			
			// Текст отзыва
			reviewTextLabel.topAnchor.constraint(equalTo: ratingImageView.bottomAnchor, constant: 6),
			reviewTextLabel.leadingAnchor.constraint(equalTo: fullNameLabel.leadingAnchor),
			reviewTextLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
			
			// Кнопка "Показать полностью..."
			showMoreButton.topAnchor.constraint(equalTo: reviewTextLabel.bottomAnchor, constant: 6),
			showMoreButton.leadingAnchor.constraint(equalTo: reviewTextLabel.leadingAnchor),
			
			// Дата (createdLabel)
			createdLabel.topAnchor.constraint(equalTo: showMoreButton.bottomAnchor, constant: 6),
			createdLabel.leadingAnchor.constraint(equalTo: showMoreButton.leadingAnchor),
			createdLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
			createdLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -9)
		])
	}
}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
