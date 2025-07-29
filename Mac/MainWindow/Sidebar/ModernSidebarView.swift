//
//  ModernSidebarView.swift
//  Feed.Fi
//
//  Modern translucent sidebar with blur effects
//

import SwiftUI
import AppKit

struct ModernSidebarView: View {
    @StateObject private var viewModel = SidebarViewModel()
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            headerView
            
            // Search Bar
            searchBar
            
            // Navigation List
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 4) {
                    ForEach(viewModel.sections, id: \.id) { section in
                        sectionView(section)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)
            }
            
            Spacer()
            
            // Bottom Actions
            bottomActionsView
        }
        .frame(minWidth: AppConfiguration.UIConfig.sidebarMinWidth,
               idealWidth: AppConfiguration.UIConfig.sidebarIdealWidth,
               maxWidth: AppConfiguration.UIConfig.sidebarMaxWidth)
        .background(
            VisualEffectView(material: .sidebar, blendingMode: .withinWindow)
                .edgesIgnoringSafeArea(.all)
        )
    }
    
    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text("Feed.Fi")
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                    .foregroundColor(.primary)
                Text("Crypto News & AI Insights")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { /* Add feed action */ }) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.accentColor)
            }
            .buttonStyle(PlainButtonStyle())
            .help("Add Feed")
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 20)
    }
    
    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
                .font(.system(size: 14))
            
            TextField("Search feeds...", text: $searchText)
                .textFieldStyle(PlainTextFieldStyle())
                .font(.system(size: 13))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.black.opacity(0.05))
        .cornerRadius(8)
        .padding(.horizontal, 16)
        .padding(.bottom, 16)
    }
    
    private func sectionView(_ section: SidebarSection) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            // Section Header
            if !section.title.isEmpty {
                Text(section.title.uppercased())
                    .font(.system(size: 10, weight: .semibold))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 4)
                    .padding(.top, 12)
            }
            
            // Section Items
            ForEach(section.items, id: \.id) { item in
                sidebarItemView(item)
            }
        }
    }
    
    private func sidebarItemView(_ item: SidebarItem) -> some View {
        Button(action: {
            viewModel.selectItem(item)
        }) {
            HStack(spacing: 12) {
                // Icon
                Group {
                    if let systemName = item.systemIcon {
                        Image(systemName: systemName)
                            .font(.system(size: 16, weight: .medium))
                    } else if let icon = item.customIcon {
                        Image(nsImage: icon)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else {
                        Circle()
                            .fill(item.color ?? .gray)
                            .frame(width: 16, height: 16)
                    }
                }
                .frame(width: 20, height: 20)
                .foregroundColor(item.color ?? .primary)
                
                // Title
                Text(item.title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                Spacer()
                
                // Unread Count
                if item.unreadCount > 0 {
                    Text("\(item.unreadCount)")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(.white)
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color.accentColor)
                        .clipShape(Capsule())
                }
                
                // AI Sentiment Indicator
                if let sentiment = item.sentiment {
                    Image(systemName: sentiment.icon)
                        .font(.system(size: 12))
                        .foregroundColor(Color(sentiment.color))
                }
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(viewModel.selectedItem?.id == item.id ? 
                          Color.accentColor.opacity(0.15) : 
                          Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            // Add hover effects if needed
        }
    }
    
    private var bottomActionsView: some View {
        VStack(spacing: 8) {
            Divider()
                .padding(.horizontal, 16)
            
            HStack(spacing: 16) {
                Button(action: { /* Settings */ }) {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .help("Settings")
                
                Button(action: { /* Refresh All */ }) {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 16))
                        .foregroundColor(.secondary)
                }
                .help("Refresh All Feeds")
                
                Spacer()
                
                // AI Status Indicator
                if AppConfiguration.shared.isAIEnabled {
                    HStack(spacing: 4) {
                        Image(systemName: "sparkles")
                            .font(.system(size: 12))
                            .foregroundColor(.green)
                        Text("AI")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(.green)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}

// MARK: - Supporting Views

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode
    
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        view.wantsLayer = true
        return view
    }
    
    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {
        nsView.material = material
        nsView.blendingMode = blendingMode
    }
}

// MARK: - View Models and Data Structures

class SidebarViewModel: ObservableObject {
    @Published var sections: [SidebarSection] = []
    @Published var selectedItem: SidebarItem?
    
    init() {
        loadSections()
    }
    
    func selectItem(_ item: SidebarItem) {
        selectedItem = item
        // Handle navigation
    }
    
    private func loadSections() {
        sections = [
            SidebarSection(
                id: "smart",
                title: "Smart Feeds",
                items: [
                    SidebarItem(id: "all", title: "All Articles", systemIcon: "doc.text", unreadCount: 42),
                    SidebarItem(id: "unread", title: "Unread", systemIcon: "circle.fill", unreadCount: 12, color: .blue),
                    SidebarItem(id: "starred", title: "Starred", systemIcon: "star.fill", color: .yellow),
                    SidebarItem(id: "today", title: "Today", systemIcon: "calendar", unreadCount: 8)
                ]
            ),
            SidebarSection(
                id: "feeds",
                title: "Feeds",
                items: [
                    SidebarItem(id: "coindesk", title: "CoinDesk", systemIcon: "bitcoinsign.circle", unreadCount: 5, sentiment: .positive),
                    SidebarItem(id: "cointelegraph", title: "Cointelegraph", systemIcon: "newspaper", unreadCount: 3, sentiment: .neutral),
                    SidebarItem(id: "decrypt", title: "Decrypt", systemIcon: "key.horizontal", unreadCount: 2, sentiment: .negative)
                ]
            )
        ]
    }
}

struct SidebarSection {
    let id: String
    let title: String
    let items: [SidebarItem]
}

struct SidebarItem {
    let id: String
    let title: String
    let systemIcon: String?
    let customIcon: NSImage?
    let unreadCount: Int
    let color: Color?
    let sentiment: SentimentResult?
    
    init(id: String, title: String, systemIcon: String? = nil, customIcon: NSImage? = nil, unreadCount: Int = 0, color: Color? = nil, sentiment: SentimentResult? = nil) {
        self.id = id
        self.title = title
        self.systemIcon = systemIcon
        self.customIcon = customIcon
        self.unreadCount = unreadCount
        self.color = color
        self.sentiment = sentiment
    }
}