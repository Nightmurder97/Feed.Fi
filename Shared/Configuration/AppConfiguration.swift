//
//  AppConfiguration.swift
//  Feed.Fi
//
//  Application configuration and environment management
//

import Foundation

struct AppConfiguration {
    static let shared = AppConfiguration()
    
    // MARK: - App Info
    let appName = "Feed.Fi"
    let bundleIdentifier = "com.feedfi.app"
    let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    
    // MARK: - AI Configuration
    private(set) var geminiAPIKey: String?
    private(set) var geminiModel: String = "models/gemini-2.5-flash-preview-05-20"
    private(set) var geminiMaxTokens: Int = 8192
    private(set) var geminiTemperature: Double = 0.3
    private(set) var geminiUseThinking: Bool = true
    private(set) var isAIEnabled: Bool = false
    private(set) var debugAILogs: Bool = false
    private(set) var aiRequestTimeout: TimeInterval = 60.0
    
    // MARK: - UI Configuration
    struct UIConfig {
        static let sidebarMinWidth: CGFloat = 280
        static let sidebarIdealWidth: CGFloat = 320
        static let sidebarMaxWidth: CGFloat = 360
        static let detailViewMinWidth: CGFloat = 384
        static let timelineItemHeight: CGFloat = 72
        static let cornerRadius: CGFloat = 10
        static let animationDuration: TimeInterval = 0.3
    }
    
    // MARK: - Colors
    struct Colors {
        static let accent = NSColor.systemBlue
        static let positive = NSColor.systemGreen
        static let negative = NSColor.systemRed
        static let neutral = NSColor.systemGray
        static let background = NSColor.controlBackgroundColor
        static let secondaryBackground = NSColor.selectedContentBackgroundColor
    }
    
    private init() {
        loadConfiguration()
    }
    
    private mutating func loadConfiguration() {
        // Load from environment variables
        geminiAPIKey = ProcessInfo.processInfo.environment["GEMINI_API_KEY"]
        isAIEnabled = geminiAPIKey != nil && !geminiAPIKey!.isEmpty
        
        // Load Gemini 2.5 configuration
        if let model = ProcessInfo.processInfo.environment["GEMINI_MODEL"] {
            geminiModel = model
        }
        
        if let maxTokensString = ProcessInfo.processInfo.environment["GEMINI_MAX_TOKENS"],
           let maxTokens = Int(maxTokensString) {
            geminiMaxTokens = maxTokens
        }
        
        if let temperatureString = ProcessInfo.processInfo.environment["GEMINI_TEMPERATURE"],
           let temperature = Double(temperatureString) {
            geminiTemperature = temperature
        }
        
        if let thinkingString = ProcessInfo.processInfo.environment["GEMINI_USE_THINKING"] {
            geminiUseThinking = thinkingString.lowercased() == "true"
        }
        
        if let debugString = ProcessInfo.processInfo.environment["DEBUG_AI_LOGS"],
           debugString.lowercased() == "true" {
            debugAILogs = true
        }
        
        if let timeoutString = ProcessInfo.processInfo.environment["AI_REQUEST_TIMEOUT"],
           let timeout = TimeInterval(timeoutString) {
            aiRequestTimeout = timeout
        }
        
        // Load from .env file if exists
        loadDotEnvFile()
    }
    
    private mutating func loadDotEnvFile() {
        guard let projectPath = Bundle.main.resourcePath?.replacingOccurrences(of: "/build/Build/Products/Debug", with: ""),
              let envPath = URL(string: "file://\(projectPath)/.env"),
              let envContent = try? String(contentsOf: envPath) else {
            return
        }
        
        let lines = envContent.components(separatedBy: .newlines)
        for line in lines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmedLine.isEmpty || trimmedLine.hasPrefix("#") {
                continue
            }
            
            let components = trimmedLine.components(separatedBy: "=")
            if components.count >= 2 {
                let key = components[0].trimmingCharacters(in: .whitespacesAndNewlines)
                let value = components[1...].joined(separator: "=").trimmingCharacters(in: .whitespacesAndNewlines)
                
                switch key {
                case "GEMINI_API_KEY":
                    if geminiAPIKey == nil || geminiAPIKey!.isEmpty {
                        geminiAPIKey = value
                        isAIEnabled = !value.isEmpty
                    }
                case "GEMINI_MODEL":
                    geminiModel = value
                case "GEMINI_MAX_TOKENS":
                    if let maxTokens = Int(value) {
                        geminiMaxTokens = maxTokens
                    }
                case "GEMINI_TEMPERATURE":
                    if let temperature = Double(value) {
                        geminiTemperature = temperature
                    }
                case "GEMINI_USE_THINKING":
                    geminiUseThinking = value.lowercased() == "true"
                case "DEBUG_AI_LOGS":
                    debugAILogs = value.lowercased() == "true"
                case "AI_REQUEST_TIMEOUT":
                    if let timeout = TimeInterval(value) {
                        aiRequestTimeout = timeout
                    }
                default:
                    break
                }
            }
        }
    }
    
    func validateConfiguration() -> [String] {
        var issues: [String] = []
        
        if !isAIEnabled {
            issues.append("AI features disabled: GEMINI_API_KEY not configured")
        }
        
        if aiRequestTimeout <= 0 {
            issues.append("Invalid AI request timeout value")
        }
        
        return issues
    }
    
    func debugInfo() -> String {
        return """
        Feed.Fi Configuration:
        - App Version: \(version)
        - AI Enabled: \(isAIEnabled)
        - Debug Logs: \(debugAILogs)
        - Request Timeout: \(aiRequestTimeout)s
        - Gemini API Key: \(geminiAPIKey?.prefix(8) ?? "None")...
        """
    }
}