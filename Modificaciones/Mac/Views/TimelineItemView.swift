import SwiftUI

struct TimelineItemView: View {
    let article: Article
    @State private var isHovered = false

    var body: some View {
        HStack(spacing: 10) {
            Image("articleThumbnail")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 56, height: 56)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 2) {
                Text(article.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                    .lineLimit(2)
                Text(article.summary ?? "")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
            Spacer()
            // Aquí puedes colocar iconos de IA como el sentimiento
        }
        .padding(8)
        .background(isHovered ? Color(NSColor.selectedContentBackgroundColor).opacity(0.2) : Color.clear)
        .cornerRadius(10)
        .onHover { hovering in
            isHovered = hovering
        }
    }
}