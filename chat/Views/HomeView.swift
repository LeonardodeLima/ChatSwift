import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var container: ServiceContainer
    @StateObject private var viewModel: HomeViewModel

    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel(service: MockChatService()))
    }

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Carregando conversas...")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else if let error = viewModel.errorMessage {
                    ErrorView(message: error) {
                        Task { await viewModel.loadChats() }
                    }
                } else {
                    List(viewModel.chats) { chat in
                        NavigationLink(destination: ChatView(chat: chat, service: container.chatService)) {
                            ChatRow(chat: chat)
                        }
                        .listRowSeparator(.visible)
                        .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("Channels")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(Color(red: 0.42, green: 0.31, blue: 0.86))
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(Color(red: 0.42, green: 0.31, blue: 0.86))
                    }
                }
            }
        }
        .task {
            await viewModel.reload(service: container.chatService)
        }
    }
}

// Subviews

private struct ChatRow: View {
    let chat: Chat

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(
                name: chat.userName,
                colorName: chat.profileColor,
                size: 58,
                avatarURL: chat.avatarURL
            )

            VStack(alignment: .leading, spacing: 5) {
                HStack(alignment: .center) {
                    HStack(spacing: 5) {
                        Text(chat.userName)
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.primary)

                        if let count = chat.memberCount, chat.isGroup {
                            Text("\(count)")
                                .font(.system(size: 13))
                                .foregroundColor(Color(.systemGray))
                            Image(systemName: "lock.fill")
                                .font(.system(size: 10))
                                .foregroundColor(Color(.systemGray))
                        }
                    }
                    Spacer()
                    Text(chat.lastMessageTime)
                        .font(.system(size: 12))
                        .foregroundColor(Color(.systemGray))
                }

                HStack(alignment: .center) {
                    Text(chat.lastMessage)
                        .font(.system(size: 14))
                        .foregroundColor(Color(.systemGray))
                        .lineLimit(1)
                    Spacer()
                    UnreadBadge(count: chat.unreadCount)
                }
            }
        }
        .padding(.vertical, 12)
    }
}

private struct ErrorView: View {
    let message: String
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 40))
                .foregroundColor(Color(.systemGray3))
            Text(message)
                .font(.system(size: 14))
                .foregroundColor(Color(.systemGray))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
            Button(action: onRetry) {
                Text("Tentar novamente")
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .background(Color(red: 0.42, green: 0.31, blue: 0.86))
                    .cornerRadius(20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    HomeView()
        .environmentObject(ServiceContainer())
}
