//
//  Errors.swift
//  Test
//
//  Created by Станислав Никулин on 28.02.2025.
//

import Foundation

enum NetworkErrors: LocalizedError {
	case invalidURL
	case noData
	case decodingFailed
	
	var errorDescription: String? {
		switch self {
		case .invalidURL:
			return "Неправильный URL"
		case .noData:
			return "Нет данных"
		case .decodingFailed:
			return "Ошибка декодирования"
		}
	}
}
