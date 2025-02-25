/// Модель отзыва.
struct Review: Decodable {
	
	/// Имя пользователя.
	let firstName: String
	/// Фамилия пользователя.
	let lastName: String
	/// Рейтинг отзыва.
	let rating: Int
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String

}
