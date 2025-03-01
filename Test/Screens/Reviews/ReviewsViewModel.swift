import UIKit

/// Класс, описывающий бизнес-логику экрана отзывов.
final class ReviewsViewModel: NSObject {

    /// Замыкание, вызываемое при изменении `state`.
    var onStateChange: ((State) -> Void)?

    private var state: State
    private let reviewsProvider: ReviewsProvider
    private let ratingRenderer: RatingRenderer
    private let decoder: JSONDecoder

    init(
        state: State = State(),
        reviewsProvider: ReviewsProvider = ReviewsProvider(),
        ratingRenderer: RatingRenderer = RatingRenderer(),
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.state = state
        self.reviewsProvider = reviewsProvider
        self.ratingRenderer = ratingRenderer
        self.decoder = decoder
    }

}

// MARK: - Internal

extension ReviewsViewModel {

    typealias State = ReviewsViewModelState

	/// Метод получения отзывов.
	func getReviews() {
		guard state.shouldLoad else { return }
		state.shouldLoad = false
		
		if state.items.isEmpty {
			state.isLoading = true
			onStateChange?(state)
		}
		
		Task { [weak self] in
			guard let self = self else { return }
			do {
				let data = try await reviewsProvider.getReviews()
				decoder.keyDecodingStrategy = .convertFromSnakeCase
				let reviews = try decoder.decode(Reviews.self, from: data)
				let prefixCount = state.limit
				var newItems = [ReviewItem]()
				for review in reviews.items.prefix(prefixCount) {
					let item = try await makeReviewItem(review)
					newItems.append(item)
				}
				
				await MainActor.run { [weak self] in
					guard let self = self else { return }
					state.items += newItems
					state.offset = state.items.count
					let remainingReviewsCount = reviews.count - state.offset
					state.limit = min(remainingReviewsCount, state.limit)
					state.shouldLoad = state.offset < reviews.count
					state.isLoading = false
					onStateChange?(state)
				}
			} catch {
				print("Ошибка получения отзывов: \(error)")
				await MainActor.run {  [weak self] in
					guard let self = self else { return }
					state.shouldLoad = true
					state.isLoading = false
					onStateChange?(state)
				}
			}
		}
	}
	
}

// MARK: - Private

private extension ReviewsViewModel {

    /// Метод, вызываемый при нажатии на кнопку "Показать полностью...".
    /// Снимает ограничение на количество строк текста отзыва (раскрывает текст).
    func showMoreReview(with id: UUID) {
        guard
            let index = state.items.firstIndex(where: { ($0 as? ReviewItem)?.id == id }),
            var item = state.items[index] as? ReviewItem
        else { return }
        item.maxLines = .zero
        state.items[index] = item
        onStateChange?(state)
    }
	
	// TODO: - При возможности переписать на Generic
	
	func downloadImage(from url: URL?) async throws -> UIImage  {
		guard let url = url else { throw NetworkErrors.invalidURL }
		let (data, _) = try await URLSession.shared.data(from: url)
		guard let image = UIImage(data: data) else { throw NetworkErrors.decodingFailed }
		return image
	}
	
	func fetchImages(photoUrls: [URL]) async throws -> [UIImage] {
		let result = try await withThrowingTaskGroup(of: UIImage.self, returning: [UIImage].self) { taskGroup in
			for url in photoUrls {
				taskGroup.addTask {
					try await self.downloadImage(from: url)
				}
			}
			var images = [UIImage]()
			for try await image in taskGroup {
				images.append(image)
			}
			return images
		}
		return result
	}

}

// MARK: - Items

private extension ReviewsViewModel {

    typealias ReviewItem = ReviewCellConfig

	func makeReviewItem(_ review: Review) async throws -> ReviewItem {
		let fullNameString = "\(review.firstName) \(review.lastName)"
		let urls = review.photoUrls.compactMap { URL(string: $0) }
		guard let avatarUrl = URL(string: review.avatarUrl) else {
			throw NetworkErrors.invalidURL
		}
		let avatarPhoto = try await downloadImage(from: avatarUrl)
		let photosImages = try await fetchImages(photoUrls: urls)
		let fullName = fullNameString.attributed(font: .username, color: .label)
        let reviewText = review.text.attributed(font: .text)
        let created = review.created.attributed(font: .created, color: .created)
		let item = ReviewItem(
			fullName: fullName,
			rating: review.rating,
			avatar: avatarPhoto,
			photos: photosImages,
			reviewText: reviewText,
			created: created,
			onTapShowMore: showMoreReview
		)
        return item
    }

}

// MARK: - UITableViewDataSource

extension ReviewsViewModel: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let config = state.items[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: config.reuseId, for: indexPath)
        config.update(cell: cell)
        return cell
    }

}

// MARK: - UITableViewDelegate

extension ReviewsViewModel: UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		state.items[indexPath.row].height(with: tableView.bounds.size)
	}

    /// Метод дозапрашивает отзывы, если до конца списка отзывов осталось два с половиной экрана по высоте.
    func scrollViewWillEndDragging(
        _ scrollView: UIScrollView,
        withVelocity velocity: CGPoint,
        targetContentOffset: UnsafeMutablePointer<CGPoint>
    ) {
        if shouldLoadNextPage(scrollView: scrollView, targetOffsetY: targetContentOffset.pointee.y) {
            getReviews()
        }
    }

    private func shouldLoadNextPage(
        scrollView: UIScrollView,
        targetOffsetY: CGFloat,
        screensToLoadNextPage: Double = 2.5
    ) -> Bool {
        let viewHeight = scrollView.bounds.height
        let contentHeight = scrollView.contentSize.height
        let triggerDistance = viewHeight * screensToLoadNextPage
        let remainingDistance = contentHeight - viewHeight - targetOffsetY
        return remainingDistance <= triggerDistance
    }

}
