//
//  ModernTimelineView.swift
//  Feed.Fi
//
//  Modern article list with image previews and AI indicators
//

import SwiftUI
import Combine

struct ModernTimelineView: View {
    @StateObject private var viewModel = TimelineViewModel()
    @State private var selectedArticle: TimelineArticle?
    @State private var hoveredArticle: String?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            headerView
            
            Divider()
            
            // Articles List
            ScrollView {
                LazyVStack(spacing: 1) {
                    ForEach(viewModel.articles, id: \.id) { article in
                        ModernTimelineItemView(
                            article: article,
                            isSelected: selectedArticle?.id == article.id,
                            isHovered: hoveredArticle == article.id
                        )
                        .onTapGesture {
                            selectedArticle = article
                            viewModel.markAsRead(article)
                        }
                        .onHover { hovering in
                            hoveredArticle = hovering ? article.id : nil
                        }
                        .contextMenu {
                            contextMenuForArticle(article)
                        }
                    }
                }
            }
            .background(Color(NSColor.controlBackgroundColor))
        }
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.feedTitle)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("\(viewModel.totalArticles) articles, \(viewModel.unreadCount) unread")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Filter and Sort Controls
            HStack(spacing: 12) {
                Menu {
                    Button("All Articles") { viewModel.filterType = .all }
                    Button("Unread Only") { viewModel.filterType = .unread }
                    Button("Starred Only") { viewModel.filterType = .starred }
                } label: {
                    Image(systemName: "line.3.horizontal.decrease.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .menuStyle(.borderlessButton)
                .help("Filter Articles")
                
                Menu {
                    Button("Newest First") { viewModel.sortOrder = .newest }
                    Button("Oldest First") { viewModel.sortOrder = .oldest }
                } label: {
                    Image(systemName: "arrow.up.arrow.down.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .menuStyle(.borderlessButton)
                .help("Sort Articles")
                
                Button(action: viewModel.refresh) {
                    Image(systemName: "arrow.clockwise.circle")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .help("Refresh")
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color(NSColor.controlBackgroundColor))
    }
    
    @ViewBuilder
    private func contextMenuForArticle(_ article: TimelineArticle) -> some View {
        Button(article.isRead ? "Mark as Unread" : "Mark as Read") {
            viewModel.toggleReadStatus(article)
        }
        
        Button(article.isStarred ? "Remove Star" : "Add Star") {
            viewModel.toggleStarred(article)
        }
        
        Divider()
        
        Button("Generate AI Summary") {
            viewModel.generateAISummary(for: article)
        }
        .disabled(!AppConfiguration.shared.isAIEnabled)
        
        Button("Analyze Sentiment") {
            viewModel.analyzeSentiment(for: article)
        }
        .disabled(!AppConfiguration.shared.isAIEnabled)
        
        Divider()
        
        Button("Share Article") {
            viewModel.shareArticle(article)
        }
        
        Button("Copy Link") {
            viewModel.copyLink(article)
        }
    }
}

struct ModernTimelineItemView: View {
    let article: TimelineArticle
    let isSelected: Bool
    let isHovered: Bool
    
    @State private var imageLoaded = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Article Image/Thumbnail
            AsyncImage(url: article.imageURL) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onAppear { imageLoaded = true }
            } placeholder: {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.2))
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                            .font(.system(size: 16))
                    )
            }
            .frame(width: 64, height: 64)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            
            // Article Content
            VStack(alignment: .leading, spacing: 4) {
                // Title and AI Indicators
                HStack(alignment: .top, spacing: 8) {
                    Text(article.title)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(article.isRead ? .secondary : .primary)
                        .lineLimit(2)
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Spacer()
                    
                    // AI Indicators
                    HStack(spacing: 4) {
                        // Sentiment Indicator
                        if let sentiment = article.aiSentiment {
                            Image(systemName: sentiment.icon)
                                .font(.system(size: 12))
                                .foregroundColor(Color(sentiment.color))
                                .help("Sentiment: \(sentiment.rawValue)")
                        }
                        
                        // AI Summary Available
                        if article.hasAISummary {
                            Image(systemName: "sparkles")
                                .font(.system(size: 12))
                                .foregroundColor(.blue)
                                .help("AI Summary Available")
                        }
                        
                        // Market Impact Level
                        if let impact = article.marketImpact {
                            Image(systemName: impact.icon)
                                .font(.system(size: 12))
                                .foregroundColor(.orange)
                                .help("Market Impact: \(impact.rawValue)")
                        }
                    }
                }
                
                // Summary/Preview
                if let summary = article.summary, !summary.isEmpty {
                    Text(summary)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                // Metadata
                HStack(spacing: 8) {
                    // Feed Name
                    Text(article.feedName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.blue)
                    
                    Text("•")
                        .foregroundColor(Color(NSColor.tertiaryLabelColor))
                    
                    // Date
                    Text(article.publishDate, style: .relative)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    // Read Status
                    if !article.isRead {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 6, height: 6)
                    }
                    
                    // Star Status
                    if article.isStarred {
                        Image(systemName: "star.fill")
                            .font(.system(size: 10))
                            .foregroundColor(.yellow)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(
            Rectangle()
                .fill(backgroundColorForState())
        )
        .animation(.easeInOut(duration: 0.15), value: isHovered)
        .animation(.easeInOut(duration: 0.15), value: isSelected)
    }
    
    private func backgroundColorForState() -> Color {
        if isSelected {
            return Color.accentColor.opacity(0.15)
        } else if isHovered {
            return Color.gray.opacity(0.08)
        } else {
            return Color.clear
        }
    }
}

// MARK: - View Model

class TimelineViewModel: ObservableObject {
    @Published var articles: [TimelineArticle] = []
    @Published var feedTitle = "All Articles"
    @Published var totalArticles = 0
    @Published var unreadCount = 0
    @Published var filterType: FilterType = .all
    @Published var sortOrder: SortOrder = .newest
    
    private var cancellables = Set<AnyCancellable>()
    private let aiService = AIServiceManager.shared
    
    enum FilterType {
        case all, unread, starred
    }
    
    enum SortOrder {
        case newest, oldest
    }
    
    init() {
        loadArticles()
        setupObservers()
    }
    
    private func setupObservers() {
        // Listen for filter and sort changes
        $filterType
            .combineLatest($sortOrder)
            .sink { [weak self] _, _ in
                self?.applyFiltersAndSort()
            }
            .store(in: &cancellables)
    }
    
    func loadArticles() {
        // Mock data - in real implementation, this would load from Core Data
        articles = [
            TimelineArticle(
                id: "1",
                title: "Bitcoin Reaches New All-Time High Amid Institutional Adoption",
                summary: "Major corporations continue to add Bitcoin to their treasury reserves as the cryptocurrency surges past previous records.",
                feedName: "CoinDesk",
                publishDate: Date().addingTimeInterval(-3600),
                imageURL: nil,
                isRead: false,
                isStarred: false,
                aiSentiment: .positive,
                hasAISummary: true,
                marketImpact: .high
            ),
            TimelineArticle(
                id: "2",
                title: "Ethereum 2.0 Staking Rewards Drop as Network Grows",
                summary: "The latest network upgrade shows promising scalability improvements but reduced staking yields concern validators.",
                feedName: "Cointelegraph",
                publishDate: Date().addingTimeInterval(-7200),
                imageURL: nil,
                isRead: true,
                isStarred: true,
                aiSentiment: .neutral,
                hasAISummary: false,
                marketImpact: .medium
            )
        ]
        
        updateCounts()
    }
    
    private func updateCounts() {
        totalArticles = articles.count
        unreadCount = articles.filter { !$0.isRead }.count
    }
    
    private func applyFiltersAndSort() {
        // Implementation for filtering and sorting
        updateCounts()
    }
    
    func markAsRead(_ article: TimelineArticle) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isRead = true
        }
        updateCounts()
    }
    
    func toggleReadStatus(_ article: TimelineArticle) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isRead.toggle()
        }
        updateCounts()
    }
    
    func toggleStarred(_ article: TimelineArticle) {
        if let index = articles.firstIndex(where: { $0.id == article.id }) {
            articles[index].isStarred.toggle()
        }
    }
    
    func generateAISummary(for article: TimelineArticle) {
        guard let index = articles.firstIndex(where: { $0.id == article.id }) else { return }
        
        aiService.summarizeArticle(article.content ?? article.summary ?? "")
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("AI Summary error: \(error)")
                    }
                },
                receiveValue: { [weak self] summary in
                    self?.articles[index].aiSummary = summary
                    self?.articles[index].hasAISummary = true
                }
            )
            .store(in: &cancellables)
    }
    
    func analyzeSentiment(for article: TimelineArticle) {
        guard let index = articles.firstIndex(where: { $0.id == article.id }) else { return }
        
        aiService.analyzeSentiment(article.title)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { completion in
                    if case .failure(let error) = completion {
                        print("Sentiment analysis error: \(error)")
                    }
                },
                receiveValue: { [weak self] sentiment in
                    self?.articles[index].aiSentiment = sentiment
                }
            )
            .store(in: &cancellables)
    }
    
    func refresh() {
        loadArticles()
    }
    
    func shareArticle(_ article: TimelineArticle) {
        // Implementation for sharing
    }
    
    func copyLink(_ article: TimelineArticle) {
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(article.url?.absoluteString ?? "", forType: .string)
    }
}

// MARK: - Data Models

struct TimelineArticle {
    let id: String
    let title: String
    let summary: String?
    let content: String?
    let feedName: String
    let publishDate: Date
    let imageURL: URL?
    let url: URL?
    var isRead: Bool
    var isStarred: Bool
    var aiSentiment: SentimentResult?
    var aiSummary: String?
    var hasAISummary: Bool
    var marketImpact: ImpactLevel?
    
    init(id: String, title: String, summary: String? = nil, content: String? = nil, feedName: String, publishDate: Date, imageURL: URL? = nil, url: URL? = nil, isRead: Bool = false, isStarred: Bool = false, aiSentiment: SentimentResult? = nil, hasAISummary: Bool = false, marketImpact: ImpactLevel? = nil) {
        self.id = id
        self.title = title
        self.summary = summary
        self.content = content
        self.feedName = feedName
        self.publishDate = publishDate
        self.imageURL = imageURL
        self.url = url
        self.isRead = isRead
        self.isStarred = isStarred
        self.aiSentiment = aiSentiment
        self.hasAISummary = hasAISummary
        self.marketImpact = marketImpact
    }
}