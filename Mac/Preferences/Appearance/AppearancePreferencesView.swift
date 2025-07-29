//
//  AppearancePreferencesView.swift
//  Feed.Fi
//
//  Appearance and customization preferences
//

import SwiftUI

struct AppearancePreferencesView: View {
    @StateObject private var themeManager = ThemeManager.shared
    @State private var selectedColorType: ColorType = .accent
    @State private var showingColorPicker = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Theme Selection
            themeSelectionView
            
            Divider()
            
            // Color Customization
            colorCustomizationView
            
            Divider()
            
            // Typography Settings
            typographyView
            
            Divider()
            
            // Layout Settings
            layoutView
            
            Spacer()
            
            // Reset Button
            HStack {
                Spacer()
                Button("Reset to Default") {
                    themeManager.resetToDefault()
                }
                .foregroundColor(.red)
            }
        }
        .padding(20)
        .frame(width: 500, height: 600)
    }
    
    private var themeSelectionView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Theme")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Choose a predefined theme or create your own custom appearance.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    themeCard(theme)
                }
            }
        }
    }
    
    private func themeCard(_ theme: AppTheme) -> some View {
        VStack(spacing: 8) {
            // Theme Preview
            RoundedRectangle(cornerRadius: 8)
                .fill(previewBackgroundColor(for: theme))
                .frame(height: 60)
                .overlay(
                    HStack(spacing: 4) {
                        Circle()
                            .fill(previewAccentColor(for: theme))
                            .frame(width: 12, height: 12)
                        
                        VStack(alignment: .leading, spacing: 2) {
                            Rectangle()
                                .fill(previewTextColor(for: theme))
                                .frame(width: 40, height: 3)
                            Rectangle()
                                .fill(previewTextColor(for: theme).opacity(0.6))
                                .frame(width: 30, height: 2)
                        }
                        
                        Spacer()
                    }
                    .padding(8)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(themeManager.currentTheme == theme ? Color.blue : Color.clear, lineWidth: 2)
                )
            
            Text(theme.displayName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            themeManager.currentTheme = theme
        }
    }
    
    private var colorCustomizationView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Colors")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Customize individual colors for your theme.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 8) {
                ForEach(ColorType.allCases, id: \.self) { colorType in
                    colorButton(colorType)
                }
            }
        }
    }
    
    private func colorButton(_ colorType: ColorType) -> some View {
        VStack(spacing: 4) {
            Button(action: {
                selectedColorType = colorType
                showingColorPicker = true
            }) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(colorForType(colorType))
                    .frame(width: 40, height: 40)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .stroke(Color.primary.opacity(0.2), lineWidth: 1)
                    )
            }
            .buttonStyle(PlainButtonStyle())
            
            Text(colorType.displayName)
                .font(.system(size: 10))
                .foregroundColor(.secondary)
                .lineLimit(1)
                .multilineTextAlignment(.center)
        }
        .frame(width: 80)
    }
    
    private var typographyView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Typography")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Adjust font sizes and weights for different text elements.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                typographyRow("Title", font: themeManager.typography.titleFont, sample: "Article Title")
                typographyRow("Headline", font: themeManager.typography.headlineFont, sample: "Section Header")
                typographyRow("Body", font: themeManager.typography.bodyFont, sample: "Article content text")
                typographyRow("Caption", font: themeManager.typography.captionFont, sample: "Metadata and labels")
            }
        }
    }
    
	private func typographyRow(_ name: String, font: NSFont?, sample: String) -> some View {
        HStack {
            Text(name)
                .font(.caption)
                .frame(width: 80, alignment: .leading)

            Text(sample)
                .font(
                    // Mapeamos NSFont → SwiftUI.Font
                    font.map { nsFont -> SwiftUI.Font in
                        let size = nsFont.pointSize
                        // Mapeo simple de peso: negrita o regular
                        let weight: SwiftUI.Font.Weight = 
                            nsFont.fontDescriptor.symbolicTraits.contains(.bold) 
                            ? .bold 
                            : .regular
                        return SwiftUI.Font.system(size: size, weight: weight)
                    }
                    // Fallback si no hay fuente personalizada
                    ?? SwiftUI.Font.body
                )
                .foregroundColor(.primary)
                .lineLimit(1)
        }
    }
    
    private var layoutView: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Layout")
                .font(.headline)
                .foregroundColor(.primary)
            
            Text("Adjust spacing and layout parameters.")
                .font(.caption)
                .foregroundColor(.secondary)
            
            VStack(spacing: 12) {
                layoutSlider("Corner Radius", value: .constant(themeManager.layout.cornerRadius), range: 0...20)
                layoutSlider("Spacing", value: .constant(themeManager.layout.spacing), range: 4...24)
                layoutSlider("Padding", value: .constant(themeManager.layout.padding), range: 8...32)
            }
        }
    }
    
    private func layoutSlider(_ name: String, value: Binding<CGFloat>, range: ClosedRange<CGFloat>) -> some View {
        HStack {
            Text(name)
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 100, alignment: .leading)
            
            Slider(value: value, in: range, step: 1)
                .frame(maxWidth: 200)
            
            Text("\(Int(value.wrappedValue))")
                .font(.caption)
                .foregroundColor(.secondary)
                .frame(width: 30, alignment: .trailing)
        }
    }
    
    // Helper functions
    private func previewBackgroundColor(for theme: AppTheme) -> Color {
        switch theme {
        case .feedFi: return Color(nsColor: NSColor.controlBackgroundColor)
        case .dark: return Color.black
        case .light: return Color.white
        case .custom: return Color(nsColor: themeManager.customColors.background)
        }
    }
    
    private func previewTextColor(for theme: AppTheme) -> Color {
        switch theme {
        case .feedFi: return Color.primary
        case .dark: return Color.white
        case .light: return Color.black
        case .custom: return Color(nsColor: themeManager.customColors.primary)
        }
    }
    
    private func previewAccentColor(for theme: AppTheme) -> Color {
        switch theme {
        case .feedFi, .dark, .light: return Color.blue
        case .custom: return Color(nsColor: themeManager.customColors.accent)
        }
    }
    
    private func colorForType(_ type: ColorType) -> Color {
        switch type {
        case .primary: return Color(nsColor: themeManager.customColors.primary)
        case .secondary: return Color(nsColor: themeManager.customColors.secondary)
        case .accent: return Color(nsColor: themeManager.customColors.accent)
        case .background: return Color(nsColor: themeManager.customColors.background)
        case .surface: return Color(nsColor: themeManager.customColors.surface)
        case .positive: return Color(nsColor: themeManager.customColors.positive)
        case .negative: return Color(nsColor: themeManager.customColors.negative)
        case .neutral: return Color(nsColor: themeManager.customColors.neutral)
        }
    }
}

struct AppearancePreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        AppearancePreferencesView()
    }
}
