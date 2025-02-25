/// Модель отзыва.
struct Review: Decodable {
	
	/// Имя пользователя
	let firstName: String
	/// Фамилия пользователя
	let lastName: String
    /// Текст отзыва.
    let text: String
    /// Время создания отзыва.
    let created: String

}
