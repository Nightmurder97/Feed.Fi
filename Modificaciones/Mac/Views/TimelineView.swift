struct TimelineItemView: View {
    let article: Article
    @State private var sentiment: String? = nil

    var body: some View {
        HStack {
            // ... imagen y título ...
            if let sentiment = sentiment {
                Image(systemName: sentimentIcon(for: sentiment))
                    .foregroundColor(sentimentColor(for: sentiment))
            }
        }
        .onAppear {
            if sentiment == nil {
                AIApi.shared.sentiment(text: article.title) { result in
                    sentiment = result
                }
            }
        }
    }

    func sentimentIcon(for sentiment: String) -> String {
        switch sentiment {
        case "positivo": return "arrow.up"
        case "negativo": return "arrow.down"
        default: return "arrow.right"
        }
    }
    func sentimentColor(for sentiment: String) -> Color {
        switch sentiment {
        case "positivo": return .green
        case "negativo": return .red
        default: return .gray
        }
    }
}