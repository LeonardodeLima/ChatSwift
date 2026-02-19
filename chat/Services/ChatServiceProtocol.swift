import Foundation

// Contrato que qualquer serviço (mock ou real) deve cumprir
protocol ChatServiceProtocol {
    func fetchChats() async throws -> [Chat]
    func fetchMessages(chatId: String) async throws -> [Message]
    func sendMessage(chatId: String, content: String) async throws -> Message
}
