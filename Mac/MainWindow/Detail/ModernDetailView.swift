//
//  ModernDetailView.swift
//  Feed.Fi
//
//  Modern article detail view with AI integration
//

import SwiftUI
import WebKit
import Combine

struct ModernDetailView: View {
    @StateObject private var viewModel = DetailViewModel()
    let article: TimelineArticle?
    
    @State private var showingAIInsights = false
    @State private var isLoadingAISummary = false
    @State private var isLoadingInsights = false
    
    var body: some View {
        Group {
            if let article = article {
                VStack(spacing: 0) {
                    // Article Header
                    articleHeaderView(article)
                    
                    // Action Bar
                    actionBarView(article)
                    
                    Divider()
                    
                    // Main Content
                    ScrollView {
                        VStack(alignment: .leading, spacing: 20) {
                            // AI Summary (if available)
                            if let summary = viewModel.aiSummary {
                                aiSummaryView(summary)
                            }
                            
                            // AI Insights Panel (if visible)
                            if showingAIInsights, let insights = viewModel.marketInsights {
                                aiInsightsView(insights)
                            }
                            
                            // Article Content
                            articleContentView(article)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 20)
                        .frame(maxWidth: 800)
                    }
                    .frame(maxWidth: .infinity)
                }
                .onAppear {
                    viewModel.loadArticle(article)
                }
            } else {
                emptyStateView
            }
        }
        .background(Color(NSColor.textBackgroundColor))
    }
    
    private func articleHeaderView(_ article: TimelineArticle) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Feed Info
            HStack(spacing: 12) {
                AsyncImage(url: article.imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.blue.opacity(0.2))
                        .overlay(
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                        )
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(article.feedName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.primary)
                    
                    Text(article.publishDate, style: .relative)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // AI Indicators
                HStack(spacing: 8) {
                    if let sentiment = article.aiSentiment {
                        HStack(spacing: 4) {
                            Image(systemName: sentiment.icon)
                                .font(.system(size: 12))
                                .foregroundColor(Color(sentiment.color))
                            Text(sentiment.rawValue.capitalized)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(Color(sentiment.color))
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color(sentiment.color).opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    if let impact = article.marketImpact {
                        HStack(spacing: 4) {
                            Image(systemName: impact.icon)
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                            Text("\(impact.rawValue) impact".capitalized)
                                .font(.system(size: 11, weight: .medium))
                                .foregroundColor(.orange)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.orange.opacity(0.1))
                        .cornerRadius(12)
                    }
                }
            }
            
            // Article Title
            Text(article.title)
                .font(.system(size: 28, weight: .bold, design: .default))
                .foregroundColor(.primary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
            
            // Article Summary
            if let summary = article.summary, !summary.isEmpty {
                Text(summary)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.secondary)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 24)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func actionBarView(_ article: TimelineArticle) -> some View {
        HStack(spacing: 16) {
            // Standard Actions
            Button(action: { viewModel.toggleStarred() }) {
                Image(systemName: article.isStarred ? "star.fill" : "star")
                    .font(.system(size: 16))
                    .foregroundColor(article.isStarred ? .yellow : .secondary)
            }
            .help(article.isStarred ? "Remove Star" : "Add Star")
            
            Button(action: { viewModel.toggleReadLater() }) {
                Image(systemName: "bookmark")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .help("Save for Later")
            
            Button(action: { viewModel.shareArticle() }) {
                Image(systemName: "square.and.arrow.up")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .help("Share Article")
            
            Button(action: { viewModel.openInBrowser() }) {
                Image(systemName: "safari")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
            }
            .help("Open in Browser")
            
            Spacer()
            
            // AI Actions
            if AppConfiguration.shared.isAIEnabled {
                Button(action: { generateAISummary() }) {
                    HStack(spacing: 6) {
                        if isLoadingAISummary {
                            ProgressView()
                                .scaleEffect(0.6)
                        } else {
                            Image(systemName: "sparkles")
                                .font(.system(size: 14))
                        }
                        Text("AI Summary")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(.blue)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.blue.opacity(0.1))
                    .cornerRadius(16)
                }
                .disabled(isLoadingAISummary)
                .help("Generate AI Summary")
                
                Button(action: { toggleAIInsights() }) {
                    HStack(spacing: 6) {
                        if isLoadingInsights {
                            ProgressView()
                                .scaleEffect(0.6)
                        } else {
                            Image(systemName: "chart.line.uptrend.xyaxis")
                                .font(.system(size: 14))
                        }
                        Text("Market Insights")
                            .font(.system(size: 13, weight: .medium))
                    }
                    .foregroundColor(showingAIInsights ? .white : .orange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(showingAIInsights ? Color.orange : Color.orange.opacity(0.1))
                    .cornerRadius(16)
                }
                .disabled(isLoadingInsights)
                .help("Show Market Insights")
            }
        }
        .padding(.horizontal, 40)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func aiSummaryView(_ summary: String) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "sparkles")
                    .font(.system(size: 16))
                    .foregroundColor(.blue)
                Text("AI Summary")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.blue)
                Spacer()
            }
            
            Text(summary)
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.primary)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .background(Color.blue.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func aiInsightsView(_ insights: MarketInsight) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 16))
                    .foregroundColor(.orange)
                Text("Market Insights")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.orange)
                Spacer()
                
                // Confidence Badge
                Text("\(Int(insights.confidence * 100))% confidence")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color.orange)
                    .cornerRadius(10)
            }
            
            Text(insights.summary)
                .font(.system(size: 14))
                .foregroundColor(.primary)
                .lineLimit(nil)
            
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Impact Level")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                    HStack(spacing: 4) {
                        Image(systemName: insights.impactLevel.icon)
                            .font(.system(size: 12))
                        Text(insights.impactLevel.rawValue.capitalized)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.orange)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text("Timeframe")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.secondary)
                    Text(insights.timeframe)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.primary)
                }
                
                if !insights.relatedCryptos.isEmpty {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Related Assets")
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundColor(.secondary)
                        HStack(spacing: 4) {
                            ForEach(insights.relatedCryptos.prefix(3), id: \.self) { crypto in
                                Text(crypto)
                                    .font(.system(size: 10, weight: .semibold))
                                    .foregroundColor(.blue)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.blue.opacity(0.1))
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
            }
        }
        .padding(16)
        .background(Color.orange.opacity(0.05))
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.orange.opacity(0.2), lineWidth: 1)
        )
    }
    
    private func articleContentView(_ article: TimelineArticle) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            // Article Image (if available)
            if let imageURL = article.imageURL {
                AsyncImage(url: imageURL) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } placeholder: {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray.opacity(0.2))
                        .frame(height: 200)
                        .overlay(
                            ProgressView()
                        )
                }
                .cornerRadius(8)
            }
            
            // Article Content
            if let content = article.content {
                Text(content)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(.primary)
                    .lineSpacing(4)
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            } else {
                Text("Full article content would be displayed here...")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .italic()
            }
        }
    }
    
    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "doc.text")
                .font(.system(size: 48))
                .foregroundColor(.secondary)
            
            Text("Select an article to read")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.secondary)
            
            Text("Choose an article from the timeline to view its content here")
                .font(.system(size: 14))
                .foregroundColor(Color(NSColor.tertiaryLabelColor))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(NSColor.textBackgroundColor))
    }
    
    private func generateAISummary() {
        guard let article = article, AppConfiguration.shared.isAIEnabled else { return }
        
        isLoadingAISummary = true
        viewModel.generateAISummary(for: article) { success in
            DispatchQueue.main.async {
                isLoadingAISummary = false
            }
        }
    }
    
    private func toggleAIInsights() {
        guard let article = article, AppConfiguration.shared.isAIEnabled else { return }
        
        if showingAIInsights {
            showingAIInsights = false
        } else {
            isLoadingInsights = true
            viewModel.generateMarketInsights(for: article) { success in
                DispatchQueue.main.async {
                    isLoadingInsights = false
                    if success {
                        showingAIInsights = true
                    }
                }
            }
        }
    }
}

// MARK: - View Model

class DetailViewModel: ObservableObject {
    @Published var currentArticle: TimelineArticle?
    @Published var aiSummary: String?
    @Published var marketInsights: MarketInsight?
    
    private var cancellables = Set<AnyCancellable>()
    private let aiService = AIServiceManager.shared
    
    func loadArticle(_ article: TimelineArticle) {
        currentArticle = article
        aiSummary = article.aiSummary
        // Load any existing insights
    }
    
    func generateAISummary(for article: TimelineArticle, completion: @escaping (Bool) -> Void) {
        let content = article.content ?? article.summary ?? article.title
        
        aiService.summarizeArticle(content)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        print("AI Summary error: \(error)")
                        completion(false)
                    }
                },
                receiveValue: { [weak self] summary in
                    self?.aiSummary = summary
                    completion(true)
                }
            )
            .store(in: &cancellables)
    }
    
    func generateMarketInsights(for article: TimelineArticle, completion: @escaping (Bool) -> Void) {
        let content = article.content ?? article.summary ?? article.title
        
        aiService.generateMarketInsight(content)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { result in
                    if case .failure(let error) = result {
                        print("Market Insights error: \(error)")
                        completion(false)
                    }
                },
                receiveValue: { [weak self] insights in
                    self?.marketInsights = insights
                    completion(true)
                }
            )
            .store(in: &cancellables)
    }
    
    func toggleStarred() {
        // Implementation for starring article
    }
    
    func toggleReadLater() {
        // Implementation for read later
    }
    
    func shareArticle() {
        // Implementation for sharing
    }
    
    func openInBrowser() {
        guard let url = currentArticle?.url else { return }
        NSWorkspace.shared.open(url)
    }
}