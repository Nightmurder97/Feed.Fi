import SwiftUI

struct ArticleActionsView: View {
    var body: some View {
        HStack(spacing: 20) {
            Button(action: /* marcar favorito */) {
                Image(systemName: "heart")
            }
            Button(action: /* guardar */) {
                Image(systemName: "bookmark")
            }
            Button(action: /* leer después */) {
                Image(systemName: "tray")
            }
            // Botón IA (resumen)
            Button(action: /* generar resumen IA */) {
                Image(systemName: "sparkles")
            }
        }
        .font(.title2)
        .padding(.vertical, 12)
        .foregroundColor(.secondary)
    }
}