import Foundation

class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var text: String = ""
    @Published var isLoading: Bool = false
    @Published var isSending: Bool = false
    @Published var errorMessage: String? = nil

    let chat: Chat
    var userName: String { chat.userName }
    var isGroup: Bool { chat.isGroup }
    var memberCount: Int? { chat.memberCount }

    private let service: ChatServiceProtocol

    init(chat: Chat, service: ChatServiceProtocol) {
        self.chat = chat
        self.service = service
        Task { await loadMessages() }
    }

    @MainActor
    func loadMessages() async {
        isLoading = true
        errorMessage = nil
        do {
            messages = try await service.fetchMessages(chatId: chat.id)
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }

    @MainActor
    func send() {
        let content = text.trimmingCharacters(in: .whitespaces)
        guard !content.isEmpty else { return }
        text = ""
        isSending = true
        Task {
            do {
                let message = try await service.sendMessage(chatId: chat.id, content: content)
                messages.append(message)
            } catch {
                errorMessage = error.localizedDescription
            }
            isSending = false
        }
    }
}
