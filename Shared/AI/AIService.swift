//
//  AIService.swift
//  Feed.Fi
//
//  AI integration service for cryptocurrency news analysis
//

import Foundation
import Combine

protocol AIServiceProtocol {
    func summarizeArticle(_ content: String) -> AnyPublisher<String, Error>
    func analyzeSentiment(_ text: String) -> AnyPublisher<SentimentResult, Error>
    func generateMarketInsight(_ article: String) -> AnyPublisher<MarketInsight, Error>
}

enum SentimentResult: String, CaseIterable {
    case positive = "positive"
    case negative = "negative"
    case neutral = "neutral"
    
    var icon: String {
        switch self {
        case .positive: return "arrow.up.circle.fill"
        case .negative: return "arrow.down.circle.fill"
        case .neutral: return "minus.circle.fill"
        }
    }
    
    var color: NSColor {
        switch self {
        case .positive: return .systemGreen
        case .negative: return .systemRed
        case .neutral: return .systemGray
        }
    }
}

struct MarketInsight {
    let summary: String
    let impactLevel: ImpactLevel
    let relatedCryptos: [String]
    let timeframe: String
    let confidence: Double
}

enum ImpactLevel: String, CaseIterable {
    case low = "low"
    case medium = "medium"
    case high = "high"
    
    var icon: String {
        switch self {
        case .low: return "chart.line.uptrend.xyaxis"
        case .medium: return "chart.bar.fill"
        case .high: return "exclamationmark.triangle.fill"
        }
    }
}

enum AIError: Error, LocalizedError {
    case invalidAPIKey
    case networkError(Error)
    case invalidResponse
    case rateLimitExceeded
    case unknown(String)
    
    var errorDescription: String? {
        switch self {
        case .invalidAPIKey:
            return "Invalid API key. Please check your Gemini API configuration."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from AI service"
        case .rateLimitExceeded:
            return "Rate limit exceeded. Please try again later."
        case .unknown(let message):
            return "Unknown error: \(message)"
        }
    }
}

class AIServiceManager: ObservableObject {
    static let shared = AIServiceManager()
    
    @Published var isEnabled: Bool = false
    @Published var currentProvider: AIProvider = .gemini
    
    private var service: AIServiceProtocol?
    
    private init() {
        setupService()
    }
    
    private func setupService() {
        switch currentProvider {
        case .gemini:
            service = GeminiAIService()
        }
        isEnabled = service != nil
    }
    
    func summarizeArticle(_ content: String) -> AnyPublisher<String, Error> {
        guard let service = service else {
            return Fail(error: AIError.invalidAPIKey).eraseToAnyPublisher()
        }
        return service.summarizeArticle(content)
    }
    
    func analyzeSentiment(_ text: String) -> AnyPublisher<SentimentResult, Error> {
        guard let service = service else {
            return Fail(error: AIError.invalidAPIKey).eraseToAnyPublisher()
        }
        return service.analyzeSentiment(text)
    }
    
    func generateMarketInsight(_ article: String) -> AnyPublisher<MarketInsight, Error> {
        guard let service = service else {
            return Fail(error: AIError.invalidAPIKey).eraseToAnyPublisher()
        }
        return service.generateMarketInsight(article)
    }
}

enum AIProvider: String, CaseIterable {
    case gemini = "gemini"
    
    var displayName: String {
        switch self {
        case .gemini: return "Google Gemini"
        }
    }
}