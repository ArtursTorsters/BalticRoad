// Wraps preview content at real iPhone point dimensions with a phone-shaped
// bezel, so layout can be judged at actual mobile size without Xcode's
// Simulator. Dev tooling only — not shipped in the app.

import SwiftUI

struct PhoneFrame<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        ZStack(alignment: .top) {
            content
                .clipShape(RoundedRectangle(cornerRadius: 40))

            Capsule()
                .fill(Color.black)
                .frame(width: 120, height: 28)
                .padding(.top, 8)
        }
        .padding(12)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: 52))
    }
}
