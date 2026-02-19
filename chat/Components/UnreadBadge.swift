import SwiftUI

struct UnreadBadge: View {
    let count: Int

    private var label: String {
        count > 99 ? "99+" : "\(count)"
    }

    var body: some View {
        if count > 0 {
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.white)
                .padding(.horizontal, 7)
                .padding(.vertical, 4)
                .background(Color(red: 0.42, green: 0.31, blue: 0.86))
                .clipShape(Capsule())
        }
    }
}

#Preview {
    HStack(spacing: 12) {
        UnreadBadge(count: 1)
        UnreadBadge(count: 9)
        UnreadBadge(count: 99)
        UnreadBadge(count: 120)
    }
    .padding()
}
