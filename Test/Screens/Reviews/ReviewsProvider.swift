import Foundation

/// Класс для загрузки отзывов.
final class ReviewsProvider {

    private let bundle: Bundle

    init(bundle: Bundle = .main) {
        self.bundle = bundle
    }

}

// MARK: - Internal

extension ReviewsProvider {

	enum GetReviewsError: Error {
		case badURL
		case badData(Error)
	}
	
	/// Асинхронный метод получения отзывов с симуляцией сетевого запроса.
	func getReviews() async throws -> Data {
		guard let url = bundle.url(forResource: "getReviews.response", withExtension: "json") else {
			throw GetReviewsError.badURL
		}
		
		// Симулируем сетевой запрос - не менять
		// Чтобы перевести фетчинг на async/await пришлось изменить логику. Суть не менял
		// usleep(.random(in: 100_000...1_000_000))
		let sleepDuration = UInt64.random(in: 100_000_000...1_000_000_000)
		try await Task.sleep(nanoseconds: sleepDuration)
		
		do {
			return try Data(contentsOf: url)
		} catch {
			throw GetReviewsError.badData(error)
		}
	}
}
