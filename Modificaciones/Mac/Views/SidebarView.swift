import SwiftUI

struct SidebarView: View {
    var body: some View {
        VStack(alignment: .leading) {
            // ... tu navegación ...
        }
        .padding(.top, 24)
        .background(
            VisualEffectView(material: .sidebar, blendingMode: .withinWindow)
        )
        .frame(minWidth: 280, idealWidth: 320, maxWidth: 360)
        .edgesIgnoringSafeArea(.all)
    }
}

// VisualEffectView para fondos translúcidos (macOS 11+)
import AppKit

struct VisualEffectView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = material
        view.blendingMode = blendingMode
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}