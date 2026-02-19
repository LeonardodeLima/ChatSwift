import Foundation

// Contém a instância única do serviço, injetada via @EnvironmentObject
class ServiceContainer: ObservableObject {
    let chatService: ChatServiceProtocol

    init(chatService: ChatServiceProtocol = MockChatService()) {
        self.chatService = chatService
    }
}
