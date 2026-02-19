import SwiftUI

struct MessageBubble: View {
    let message: Message
    let senderName: String
    var avatarURL: String? = nil

    private let purpleColor = Color(red: 0.42, green: 0.31, blue: 0.86)

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if message.isFromCurrentUser {
                Spacer()
                bubbleWithMeta(alignRight: true)
            } else {
                AvatarView(name: senderName, colorName: "purple", size: 28, avatarURL: avatarURL)
                VStack(alignment: .leading, spacing: 2) {
                    Text(senderName)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(Color(.systemGray))
                    bubbleWithMeta(alignRight: false)
                }
                Spacer()
            }
        }
        .padding(.horizontal, 12)
    }

    @ViewBuilder
    private func bubbleWithMeta(alignRight: Bool) -> some View {
        Text(message.content)
            .font(.system(size: 15))
            .foregroundColor(message.isFromCurrentUser ? .white : .primary)
            .padding(.top, 10)
            .padding(.leading, 14)
            .padding(.trailing, alignRight ? 60 : 14)
            .padding(.bottom, 22)
            .background(
                ZStack(alignment: .bottomTrailing) {
                    message.isFromCurrentUser ? purpleColor : Color(.systemGray6)
                    metaOverlay
                        .padding(.trailing, 8)
                        .padding(.bottom, 5)
                }
            )
            .cornerRadius(18)
            .frame(maxWidth: 280, alignment: alignRight ? .trailing : .leading)
    }

    private var metaOverlay: some View {
        HStack(spacing: 3) {
            Text(message.timestamp, style: .time)
                .font(.system(size: 10))
                .foregroundColor(message.isFromCurrentUser ? .white.opacity(0.75) : Color(.systemGray))

            if message.isFromCurrentUser {
                if message.isRead {
                    ZStack {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .offset(x: -3)
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .offset(x: 3)
                    }
                    .foregroundColor(.white.opacity(0.9))
                    .frame(width: 16)
                } else {
                    Image(systemName: "arrow.clockwise")
                        .font(.system(size: 9))
                        .foregroundColor(.white.opacity(0.75))
                }
            }
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        MessageBubble(
            message: Message(content: "Oi, tudo bem?", timestamp: Date(), isFromCurrentUser: false),
            senderName: "Katherine"
        )
        MessageBubble(
            message: Message(content: "Tudo sim!", timestamp: Date(), isFromCurrentUser: true, isRead: true),
            senderName: "Katherine"
        )
        MessageBubble(
            message: Message(content: "Enviando...", timestamp: Date(), isFromCurrentUser: true),
            senderName: "Katherine"
        )
    }
    .padding(.vertical)
}
