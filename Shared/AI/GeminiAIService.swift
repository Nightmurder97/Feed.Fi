//
//  GeminiAIService.swift
//  Feed.Fi
//
//  Gemini API integration for cryptocurrency news analysis
//

import Foundation
import Combine

class GeminiAIService: AIServiceProtocol {
    private let apiKey: String
    private let baseURL = "https://generativelanguage.googleapis.com/v1beta/models"
    private let session = URLSession.shared
    
    init?() {
        guard let key = ProcessInfo.processInfo.environment["GEMINI_API_KEY"],
              !key.isEmpty else {
            print("Warning: GEMINI_API_KEY not found in environment variables")
            return nil
        }
        self.apiKey = key
    }
    
    func summarizeArticle(_ content: String) -> AnyPublisher<String, Error> {
        let prompt = """
        Analiza el siguiente artículo sobre criptomonedas y genera un resumen conciso y profesional en español de máximo 3 párrafos. 
        Enfócate en los puntos clave para inversores y traders:
        
        \(content)
        """
        
        return generateContent(with: prompt)
    }
    
    func analyzeSentiment(_ text: String) -> AnyPublisher<SentimentResult, Error> {
        let prompt = """
        Analiza el sentimiento del siguiente titular de noticias sobre criptomonedas. 
        Responde únicamente con una de estas palabras: "positive", "negative", o "neutral".
        
        Titular: \(text)
        """
        
        return generateContent(with: prompt)
            .map { response in
                let cleanResponse = response.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
                return SentimentResult(rawValue: cleanResponse) ?? .neutral
            }
            .eraseToAnyPublisher()
    }
    
    func generateMarketInsight(_ article: String) -> AnyPublisher<MarketInsight, Error> {
        let prompt = """
        Analiza el siguiente artículo de criptomonedas y genera un insight de mercado en formato JSON con los siguientes campos:
        - summary: resumen del impacto (máximo 100 palabras)
        - impactLevel: "low", "medium", o "high"
        - relatedCryptos: array de símbolos de criptomonedas mencionadas (ej: ["BTC", "ETH"])
        - timeframe: horizonte temporal del impacto (ej: "corto plazo", "mediano plazo")
        - confidence: nivel de confianza del análisis (0.0 a 1.0)
        
        Artículo: \(article)
        
        Responde únicamente con el JSON válido:
        """
        
        return generateContent(with: prompt)
            .tryMap { response in
                guard let data = response.data(using: .utf8),
                      let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let summary = json["summary"] as? String,
                      let impactLevelString = json["impactLevel"] as? String,
                      let impactLevel = ImpactLevel(rawValue: impactLevelString),
                      let relatedCryptos = json["relatedCryptos"] as? [String],
                      let timeframe = json["timeframe"] as? String,
                      let confidence = json["confidence"] as? Double else {
                    throw AIError.invalidResponse
                }
                
                return MarketInsight(
                    summary: summary,
                    impactLevel: impactLevel,
                    relatedCryptos: relatedCryptos,
                    timeframe: timeframe,
                    confidence: confidence
                )
            }
            .eraseToAnyPublisher()
    }
    
    private func generateContent(with prompt: String) -> AnyPublisher<String, Error> {
        // Actualizado a Gemini 2.5 Flash para optimización precio-rendimiento y pensamiento adaptativo
        let url = URL(string: "\(baseURL)/gemini-2.5-flash-preview-05-20:generateContent?key=\(apiKey)")!
        
        let requestBody: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        ["text": prompt]
                    ]
                ]
            ],
            "generationConfig": [
                "maxOutputTokens": 8192,  // Optimizado para Gemini 2.5 Flash
                "temperature": 0.3,
                "topP": 0.8,
                "topK": 40
            ],
            "safetySettings": [
                [
                    "category": "HARM_CATEGORY_HARASSMENT",
                    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
                ],
                [
                    "category": "HARM_CATEGORY_HATE_SPEECH",
                    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
                ],
                [
                    "category": "HARM_CATEGORY_SEXUALLY_EXPLICIT",
                    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
                ],
                [
                    "category": "HARM_CATEGORY_DANGEROUS_CONTENT",
                    "threshold": "BLOCK_MEDIUM_AND_ABOVE"
                ]
            ]
        ]
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody)
        } catch {
            return Fail(error: AIError.networkError(error)).eraseToAnyPublisher()
        }
        
        return session.dataTaskPublisher(for: request)
            .map(\.data)
            .tryMap { data in
                guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                      let candidates = json["candidates"] as? [[String: Any]],
                      let firstCandidate = candidates.first,
                      let content = firstCandidate["content"] as? [String: Any],
                      let parts = content["parts"] as? [[String: Any]],
                      let firstPart = parts.first,
                      let text = firstPart["text"] as? String else {
                    throw AIError.invalidResponse
                }
                return text
            }
            .mapError { error in
                if error is AIError {
                    return error
                } else {
                    return AIError.networkError(error)
                }
            }
            .eraseToAnyPublisher()
    }
}