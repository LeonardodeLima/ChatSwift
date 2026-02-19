import SwiftUI

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel

    private let purpleColor = Color(red: 0.42, green: 0.31, blue: 0.86)

    init(chat: Chat, service: ChatServiceProtocol) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(chat: chat, service: service))
    }

    // Agrupa mensagens por dia para exibir separadores de data dinâmicos
    private var groupedMessages: [(date: String, messages: [Message])] {
        let calendar = Calendar.current
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "pt_BR")

        var groups: [(date: String, messages: [Message])] = []
        var currentDay: Date? = nil
        var currentMessages: [Message] = []

        for message in viewModel.messages {
            let day = calendar.startOfDay(for: message.timestamp)
            if let last = currentDay, calendar.isDate(last, inSameDayAs: day) {
                currentMessages.append(message)
            } else {
                if !currentMessages.isEmpty, let last = currentDay {
                    groups.append((date: label(for: last, formatter: formatter), messages: currentMessages))
                }
                currentDay = day
                currentMessages = [message]
            }
        }

        if !currentMessages.isEmpty, let last = currentDay {
            groups.append((date: label(for: last, formatter: formatter), messages: currentMessages))
        }

        return groups
    }

    private func label(for date: Date, formatter: DateFormatter) -> String {
        let calendar = Calendar.current
        if calendar.isDateInToday(date) {
            return "Hoje"
        } else if calendar.isDateInYesterday(date) {
            return "Ontem"
        } else {
            formatter.dateFormat = "EEE, d MMM"
            return formatter.string(from: date).capitalized
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            if viewModel.isLoading {
                ProgressView("Carregando mensagens...")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 6) {
                            // Cabeçalho do canal
                            DateDivider(text: "Qua, 21 de dez")
                            Text("\(viewModel.userName) entrou neste canal.")
                                .font(.system(size: 12))
                                .foregroundColor(Color(.systemGray))
                                .padding(.bottom, 4)

                            // Mensagens agrupadas por data
                            ForEach(groupedMessages, id: \.date) { group in
                                DateDivider(text: group.date)
                                ForEach(group.messages) { message in
                                    MessageBubble(
                                        message: message,
                                        senderName: viewModel.userName,
                                        avatarURL: viewModel.chat.avatarURL
                                    )
                                    .id(message.id)
                                }
                            }

                            if viewModel.isSending {
                                HStack {
                                    Spacer()
                                    ProgressView()
                                        .padding(.trailing, 20)
                                        .padding(.vertical, 4)
                                }
                            }
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 12)
                    }
                    .onChange(of: viewModel.messages.count) { _ in
                        if let last = viewModel.messages.last {
                            withAnimation { proxy.scrollTo(last.id, anchor: .bottom) }
                        }
                    }
                }
            }

            if let error = viewModel.errorMessage {
                Text(error)
                    .font(.system(size: 12))
                    .foregroundColor(.red)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 6)
            }

            MessageInputBar(text: $viewModel.text, onSend: viewModel.send, isSending: viewModel.isSending)
        }
        .navigationTitle(viewModel.userName)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(systemName: "info.circle")
                        .foregroundColor(purpleColor)
                }
            }
        }
    }
}

// Subviews

private struct DateDivider: View {
    let text: String

    var body: some View {
        HStack {
            Spacer()
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(Color(.systemGray))
                .padding(.horizontal, 12)
                .padding(.vertical, 4)
                .background(Color(.systemGray6))
                .cornerRadius(10)
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

private struct MessageInputBar: View {
    @Binding var text: String
    let onSend: () -> Void
    let isSending: Bool

    private let purpleColor = Color(red: 0.42, green: 0.31, blue: 0.86)

    var body: some View {
        HStack(spacing: 8) {
            TextField("Digite uma mensagem...", text: $text)
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(20)

            Button(action: onSend) {
                Image(systemName: "paperplane.fill")
                    .foregroundColor(.white)
                    .padding(10)
                    .background(text.isEmpty || isSending ? Color.gray : purpleColor)
                    .clipShape(Circle())
            }
            .disabled(text.isEmpty || isSending)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(Color(.systemBackground))
        .overlay(Divider(), alignment: .top)
    }
}

#Preview {
    NavigationView {
        ChatView(
            chat: Chat(
                id: "294710",
                userName: "Katherine",
                profileColor: "purple",
                avatarURL: "https://testingbot.com/free-online-tools/random-avatar/100",
                lastMessage: "Let me see.",
                lastMessageTime: "7:30 PM",
                unreadCount: 0,
                messages: []
            ),
            service: MockChatService()
        )
    }
}
