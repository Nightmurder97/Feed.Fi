//
//  ThemeManager.swift
//  Feed.Fi
//
//  Theme and customization management system
//

import AppKit
import Combine

class ThemeManager: ObservableObject {
    static let shared = ThemeManager()
    
    @Published var currentTheme: AppTheme = .feedFi
    @Published var customColors: CustomColors = CustomColors()
    @Published var typography: Typography = Typography()
    @Published var layout: LayoutConfig = LayoutConfig()
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        loadSavedTheme()
        setupObservers()
    }
    
    private func setupObservers() {
        $currentTheme
            .sink { [weak self] theme in
                self?.applyTheme(theme)
                self?.saveTheme()
            }
            .store(in: &cancellables)
    }
    
    private func loadSavedTheme() {
        if let themeData = UserDefaults.standard.data(forKey: "selectedTheme"),
           let theme = try? JSONDecoder().decode(AppTheme.self, from: themeData) {
            currentTheme = theme
        }
        
        // CustomColors and Typography are not persisted as NSColor/NSFont can't be easily serialized
        // Default colors and typography will be loaded from theme defaults
    }
    
    private func saveTheme() {
        if let themeData = try? JSONEncoder().encode(currentTheme) {
            UserDefaults.standard.set(themeData, forKey: "selectedTheme")
        }
        
        // CustomColors and Typography are not persisted as NSColor/NSFont can't be easily serialized
    }
    
    private func applyTheme(_ theme: AppTheme) {
        switch theme {
        case .feedFi:
            applyFeedFiTheme()
        case .dark:
            applyDarkTheme()
        case .light:
            applyLightTheme()
        case .custom:
            applyCustomTheme()
        }
    }
    
    private func applyFeedFiTheme() {
        customColors = CustomColors(
            primary: NSColor.labelColor,
            secondary: NSColor.secondaryLabelColor,
            accent: NSColor.controlAccentColor,
            background: NSColor.controlBackgroundColor,
            surface: NSColor.textBackgroundColor,
            positive: NSColor.systemGreen,
            negative: NSColor.systemRed,
            neutral: NSColor.systemGray
        )
        
        typography = Typography(
            titleFont: NSFont.systemFont(ofSize: 28, weight: .bold),
            headlineFont: NSFont.systemFont(ofSize: 16, weight: .semibold),
            bodyFont: NSFont.systemFont(ofSize: 14, weight: .regular),
            captionFont: NSFont.systemFont(ofSize: 12, weight: .medium),
            buttonFont: NSFont.systemFont(ofSize: 14, weight: .medium)
        )
    }
    
    private func applyDarkTheme() {
        customColors = CustomColors(
            primary: NSColor.labelColor,
            secondary: NSColor.secondaryLabelColor,
            accent: NSColor.controlAccentColor,
            background: NSColor.black,
            surface: NSColor.controlBackgroundColor,
            positive: NSColor.systemGreen,
            negative: NSColor.systemRed,
            neutral: NSColor.systemGray
        )
    }
    
    private func applyLightTheme() {
        customColors = CustomColors(
            primary: NSColor.labelColor,
            secondary: NSColor.secondaryLabelColor,
            accent: NSColor.controlAccentColor,
            background: NSColor.white,
            surface: NSColor.textBackgroundColor,
            positive: NSColor.systemGreen,
            negative: NSColor.systemRed,
            neutral: NSColor.systemGray
        )
    }
    
    private func applyCustomTheme() {
        // Use the custom colors as they are
    }
    
    func updateColor(_ colorType: ColorType, color: NSColor) {
        switch colorType {
        case .primary:
            customColors.primary = color
        case .secondary:
            customColors.secondary = color
        case .accent:
            customColors.accent = color
        case .background:
            customColors.background = color
        case .surface:
            customColors.surface = color
        case .positive:
            customColors.positive = color
        case .negative:
            customColors.negative = color
        case .neutral:
            customColors.neutral = color
        }
        
        if currentTheme != .custom {
            currentTheme = .custom
        }
        
        saveTheme()
    }
    
    func updateTypography(_ typography: Typography) {
        self.typography = typography
        saveTheme()
    }
    
    func resetToDefault() {
        currentTheme = .feedFi
    }
}

// MARK: - Data Models

enum AppTheme: String, CaseIterable, Codable {
    case feedFi = "feedfi"
    case dark = "dark"
    case light = "light"
    case custom = "custom"
    
    var displayName: String {
        switch self {
        case .feedFi: return "Feed.Fi"
        case .dark: return "Dark"
        case .light: return "Light"
        case .custom: return "Custom"
        }
    }
}

enum ColorType: String, CaseIterable {
    case primary = "primary"
    case secondary = "secondary"
    case accent = "accent"
    case background = "background"
    case surface = "surface"
    case positive = "positive"
    case negative = "negative"
    case neutral = "neutral"
    
    var displayName: String {
        switch self {
        case .primary: return "Primary Text"
        case .secondary: return "Secondary Text"
        case .accent: return "Accent Color"
        case .background: return "Background"
        case .surface: return "Surface"
        case .positive: return "Positive (Bullish)"
        case .negative: return "Negative (Bearish)"
        case .neutral: return "Neutral"
        }
    }
}

struct CustomColors {
    var primary: NSColor
    var secondary: NSColor
    var accent: NSColor
    var background: NSColor
    var surface: NSColor
    var positive: NSColor
    var negative: NSColor
    var neutral: NSColor
    
    init(primary: NSColor = NSColor.labelColor,
         secondary: NSColor = NSColor.secondaryLabelColor,
         accent: NSColor = NSColor.controlAccentColor,
         background: NSColor = NSColor.controlBackgroundColor,
         surface: NSColor = NSColor.textBackgroundColor,
         positive: NSColor = NSColor.systemGreen,
         negative: NSColor = NSColor.systemRed,
         neutral: NSColor = NSColor.systemGray) {
        self.primary = primary
        self.secondary = secondary
        self.accent = accent
        self.background = background
        self.surface = surface
        self.positive = positive
        self.negative = negative
        self.neutral = neutral
    }
}

struct Typography {
    var titleFont: NSFont
    var headlineFont: NSFont
    var bodyFont: NSFont
    var captionFont: NSFont
    var buttonFont: NSFont
    
    init(titleFont: NSFont = NSFont.systemFont(ofSize: 28, weight: .bold),
         headlineFont: NSFont = NSFont.systemFont(ofSize: 16, weight: .semibold),
         bodyFont: NSFont = NSFont.systemFont(ofSize: 14, weight: .regular),
         captionFont: NSFont = NSFont.systemFont(ofSize: 12, weight: .medium),
         buttonFont: NSFont = NSFont.systemFont(ofSize: 14, weight: .medium)) {
        self.titleFont = titleFont
        self.headlineFont = headlineFont
        self.bodyFont = bodyFont
        self.captionFont = captionFont
        self.buttonFont = buttonFont
    }
}

struct LayoutConfig: Codable {
    var cornerRadius: CGFloat
    var spacing: CGFloat
    var padding: CGFloat
    var animationDuration: Double
    
    init(cornerRadius: CGFloat = 8,
         spacing: CGFloat = 12,
         padding: CGFloat = 16,
         animationDuration: Double = 0.3) {
        self.cornerRadius = cornerRadius
        self.spacing = spacing
        self.padding = padding
        self.animationDuration = animationDuration
    }
}

// MARK: - Color and Font Management Notes
// NSColor and NSFont cannot conform to Codable as they are not final classes
// Theme colors and typography are managed in-memory and recreated from theme defaults

// NSFont extensions removed as they cannot conform to Codable
// Typography configuration is handled through direct font creation