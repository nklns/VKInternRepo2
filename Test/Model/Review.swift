/// Модель отзыва.
struct Review: Decodable {
	
	/// Имя пользователя.
	let firstName: String
	/// Фамилия пользователя.
	let lastName: String
	/// Рейтинг отзыва.
	let rating: Int
	/// URL на фото аватара.
	let avatarUrl: String
	/// Массив URL на фото отзывов.
	let photoUrls: [String]
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String

}
