import Foundation

class HomeViewModel: ObservableObject {
    @Published var chats: [Chat] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private var service: ChatServiceProtocol

    init(service: ChatServiceProtocol = MockChatService()) {
        self.service = service
        Task { await loadChats() }
    }

    // Chamado após receber o serviço compartilhado via EnvironmentObject
    @MainActor
    func reload(service: ChatServiceProtocol) async {
        self.service = service
        await loadChats()
    }

    @MainActor
    func loadChats() async {
        isLoading = true
        errorMessage = nil
        do {
            chats = try await service.fetchChats()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
