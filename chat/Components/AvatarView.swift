import SwiftUI

struct AvatarView: View {
    let name: String
    let colorName: String
    let size: CGFloat
    var avatarURL: String? = nil

    var initials: String {
        let parts = name.split(separator: " ")
        if parts.count >= 2 {
            return String(parts[0].prefix(1)) + String(parts[1].prefix(1))
        }
        return String(name.prefix(2)).uppercased()
    }

    var body: some View {
        ZStack {
            if let urlStr = avatarURL, let url = URL(string: urlStr) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: size, height: size)
                            .clipShape(Circle())
                    default:
                        fallbackAvatar
                    }
                }
            } else {
                fallbackAvatar
            }
        }
    }

    private var fallbackAvatar: some View {
        ZStack {
            Circle()
                .fill(Color.avatarColor(colorName))
                .frame(width: size, height: size)
            Text(initials)
                .font(.system(size: size * 0.36, weight: .semibold))
                .foregroundColor(.white)
        }
    }
}

#Preview {
    HStack(spacing: 16) {
        AvatarView(name: "Katherine", colorName: "purple", size: 52)
        AvatarView(name: "Sunday Brunch", colorName: "orange", size: 52)
        AvatarView(name: "Julia Jeff", colorName: "blue", size: 52)
    }
    .padding()
}
