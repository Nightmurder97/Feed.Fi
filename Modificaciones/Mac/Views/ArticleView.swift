import SwiftUI

struct ArticleView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 12) {
                    Image("feedIcon") // Usa el favicon del feed
                        .resizable()
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                    VStack(alignment: .leading) {
                        Text(article.feedTitle)
                            .font(.title3).bold()
                        Text(article.author ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .lineLimit(1)
                    }
                }
                Text(article.title)
                    .font(.largeTitle).bold()
                    .padding(.bottom, 4)
                Text(article.summary ?? "")
                    .font(.title3)
                    .foregroundColor(.primary)
                Divider().padding(.vertical, 8)
                // Aquí iría el cuerpo del artículo, imágenes, etc.
            }
            .padding()
        }
        .background(Color(NSColor.textBackgroundColor))
    }
}