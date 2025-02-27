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

	/// Объект, хранящий посчитанные фреймы для ячейки отзыва.
	fileprivate let layout = ReviewCellLayout()

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

	/// Метод, возвращаюший высоту ячейки с данным ограничением по размеру.
	/// Вызывается из `heightForRowAt:` делегата таблицы.
	func height(with size: CGSize) -> CGFloat {
		layout.height(config: self, maxWidth: size.width)
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
	
	fileprivate let fullNameLabel = UILabel()
	fileprivate let reviewTextLabel = UILabel()
	fileprivate let createdLabel = UILabel()
	fileprivate let showMoreButton = UIButton()
	fileprivate let avatarImageView = UIImageView()
	fileprivate let ratingImageView = UIImageView()

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
		super.init(style: style, reuseIdentifier: reuseIdentifier)
		setupCell()
	}

	override func layoutSubviews() {
		super.layoutSubviews()
		guard let layout = config?.layout else { return }
		reviewTextLabel.frame = layout.reviewTextLabelFrame
		createdLabel.frame = layout.createdLabelFrame
		showMoreButton.frame = layout.showMoreButtonFrame
		avatarImageView.frame = layout.avatarImageViewFrame
		fullNameLabel.frame = layout.fullNameLabelFrame
		ratingImageView.frame = layout.ratingImageViewFrame
	}

}

// MARK: - Private

private extension ReviewCell {

	func setupCell() {
		setupReviewTextLabel()
		setupCreatedLabel()
		setupShowMoreButton()
		setupAvatarImageView()
		setupFullNameLabel()
		setupRatingImageView()
	}

	func setupReviewTextLabel() {
		contentView.addSubview(reviewTextLabel)
		reviewTextLabel.lineBreakMode = .byWordWrapping
	}

	func setupCreatedLabel() {
		contentView.addSubview(createdLabel)
	}

	func setupShowMoreButton() {
		contentView.addSubview(showMoreButton)
		showMoreButton.contentVerticalAlignment = .fill
		showMoreButton.setAttributedTitle(Config.showMoreText, for: .normal)
		showMoreButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
	}
	
	func setupAvatarImageView() {
		contentView.addSubview(avatarImageView)
		avatarImageView.contentMode = .scaleAspectFill
		avatarImageView.clipsToBounds = true
		avatarImageView.layer.cornerRadius = ReviewCellLayout.avatarCornerRadius
	
		avatarImageView.image = UIImage(named: "l5w5aIHioYc")
	}
	
	func setupFullNameLabel() {
		contentView.addSubview(fullNameLabel)
	}
	
	func setupRatingImageView() {
		contentView.addSubview(ratingImageView)
	}
	
}

// MARK: - Layout

/// Класс, в котором происходит расчёт фреймов для сабвью ячейки отзыва.
/// После расчётов возвращается актуальная высота ячейки.
private final class ReviewCellLayout {

	// MARK: - Размеры

	fileprivate static let avatarSize = CGSize(width: 36.0, height: 36.0)
	fileprivate static let avatarCornerRadius = 18.0
	fileprivate static let photoCornerRadius = 8.0

	private static let photoSize = CGSize(width: 55.0, height: 66.0)
	private static let showMoreButtonSize = Config.showMoreText.size()

	// MARK: - Фреймы

	private(set) var reviewTextLabelFrame = CGRect.zero
	private(set) var showMoreButtonFrame = CGRect.zero
	private(set) var createdLabelFrame = CGRect.zero
	private(set) var avatarImageViewFrame = CGRect.zero
	private(set) var fullNameLabelFrame = CGRect.zero
	private(set) var ratingImageViewFrame = CGRect.zero
	// MARK: - Отступы

	/// Отступы от краёв ячейки до её содержимого.
	private let insets = UIEdgeInsets(top: 9.0, left: 12.0, bottom: 9.0, right: 12.0)

	/// Горизонтальный отступ от аватара до имени пользователя.
	private let avatarToUsernameSpacing = 10.0
	/// Вертикальный отступ от имени пользователя до вью рейтинга.
	private let usernameToRatingSpacing = 6.0
	/// Вертикальный отступ от вью рейтинга до текста (если нет фото).
	private let ratingToTextSpacing = 6.0
	/// Вертикальный отступ от вью рейтинга до фото.
	private let ratingToPhotosSpacing = 10.0
	/// Горизонтальные отступы между фото.
	private let photosSpacing = 8.0
	/// Вертикальный отступ от фото (если они есть) до текста отзыва.
	private let photosToTextSpacing = 10.0
	/// Вертикальный отступ от текста отзыва до времени создания отзыва или кнопки "Показать полностью..." (если она есть).
	private let reviewTextToCreatedSpacing = 6.0
	/// Вертикальный отступ от кнопки "Показать полностью..." до времени создания отзыва.
	private let showMoreToCreatedSpacing = 6.0

	// MARK: - Расчёт фреймов и высоты ячейки

	/// Возвращает высоту ячейку с данной конфигурацией `config` и ограничением по ширине `maxWidth`.
	func height(config: Config, maxWidth: CGFloat) -> CGFloat {
		let ratingStarsConfig = RatingRendererConfig.default()
		let ratingWidth = (ratingStarsConfig.starImage.size.width + ratingStarsConfig.spacing)
		* CGFloat(ratingStarsConfig.ratingRange.count) - ratingStarsConfig.spacing
		
		var maxY = insets.top
		var showShowMoreButton = false

		avatarImageViewFrame = CGRect(
			origin: CGPoint(x: insets.left, y: maxY),
			size: Self.avatarSize
		)
		
		let contentStartX = avatarImageViewFrame.maxX + avatarToUsernameSpacing
		let availableWidth = maxWidth - contentStartX - insets.right
		
		fullNameLabelFrame = CGRect(
			origin: CGPoint(x: contentStartX, y: maxY),
			size: config.fullName.boundingRect(width: availableWidth).size
		)
			
		maxY = fullNameLabelFrame.maxY + usernameToRatingSpacing
		
		ratingImageViewFrame = CGRect(
			origin: CGPoint(x: contentStartX, y: maxY),
			size: CGSize(width: ratingWidth, height: ratingStarsConfig.starImage.size.height)
		)
		
		maxY = ratingImageViewFrame.maxY + ratingToTextSpacing
		
		if !config.reviewText.isEmpty() {
			// Высота текста с текущим ограничением по количеству строк.
			let currentTextHeight = (config.reviewText.font()?.lineHeight ?? .zero) * CGFloat(config.maxLines)
			// Максимально возможная высота текста, если бы ограничения не было.
			let actualTextHeight = config.reviewText.boundingRect(width: availableWidth).size.height
			// Показываем кнопку "Показать полностью...", если максимально возможная высота текста больше текущей.
			showShowMoreButton = config.maxLines != .zero && actualTextHeight > currentTextHeight

			reviewTextLabelFrame = CGRect(
				origin: CGPoint(x: contentStartX, y: maxY),
				size: config.reviewText.boundingRect(width: availableWidth, height: currentTextHeight).size
			)
			maxY = reviewTextLabelFrame.maxY + reviewTextToCreatedSpacing
		}

		if showShowMoreButton {
			showMoreButtonFrame = CGRect(
				origin: CGPoint(x: contentStartX, y: maxY),
				size: Self.showMoreButtonSize
			)
			maxY = showMoreButtonFrame.maxY + showMoreToCreatedSpacing
		} else {
			showMoreButtonFrame = .zero
		}

		createdLabelFrame = CGRect(
			origin: CGPoint(x: contentStartX, y: maxY),
			size: config.created.boundingRect(width: availableWidth).size
		)

		return createdLabelFrame.maxY + insets.bottom
	}

}

// MARK: - Actions

private extension ReviewCell {
	@objc
	func buttonTapped() {
		guard let config = config else { return }
		config.onTapShowMore(config.id)
	}
}

// MARK: - Typealias

fileprivate typealias Config = ReviewCellConfig
fileprivate typealias Layout = ReviewCellLayout
