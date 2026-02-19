import Foundation

class MockChatService: ChatServiceProtocol {

    var shouldFail: Bool = false
    var delay: TimeInterval = 1.0

    private static let idBrunch   = "481392"
    private static let idCatarina = "739201"
    private static let idTenis    = "562847"
    private static let idJulia    = "318904"

    private var chatsDB: [String: Chat] = [:]


    init() {
        seedDatabase()
    }

    // Protocol

    func fetchChats() async throws -> [Chat] {
        try await simulateNetwork()
        return Array(chatsDB.values).sorted { $0.lastMessageTime > $1.lastMessageTime }
    }

    func fetchMessages(chatId: String) async throws -> [Message] {
        try await simulateNetwork()
        guard let chat = chatsDB[chatId] else {
            throw ServiceError.notFound("Chat \(chatId) não encontrado")
        }
        return chat.messages
    }

    func sendMessage(chatId: String, content: String) async throws -> Message {
        try await simulateNetwork()
        guard chatsDB[chatId] != nil else {
            throw ServiceError.notFound("Chat \(chatId) não encontrado")
        }
        let message = Message(content: content, timestamp: Date(), isFromCurrentUser: true)
        chatsDB[chatId]?.messages.append(message)
        return message
    }

    // Helpers

    private func simulateNetwork() async throws {
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        if shouldFail {
            throw ServiceError.networkError("Sem conexão com a internet")
        }
    }

    // Seed

    private func seedDatabase() {
        let chats: [Chat] = [
            Chat(
                id: Self.idBrunch,
                userName: "Brunch de Domingo",
                profileColor: "orange",
                avatarURL: "https://testingbot.com/free-online-tools/random-avatar/101",
                lastMessage: "Que tal o restaurante do Zé?",
                lastMessageTime: "20:18",
                unreadCount: 9,
                messages: [
                    Message(content: "Oi galera!", timestamp: Date(), isFromCurrentUser: false),
                    Message(content: "Que tal o restaurante do Zé?", timestamp: Date(), isFromCurrentUser: false)
                ],
                isGroup: true,
                memberCount: 12
            ),
            Chat(
                id: Self.idCatarina,
                userName: "Catarina",
                profileColor: "purple",
                avatarURL: "https://testingbot.com/free-online-tools/random-avatar/120",
                lastMessage: "Vou levar ele ao veterinário.",
                lastMessageTime: "19:30",
                unreadCount: 0,
                messages: [
                    Message(content: "Tem algo errado com o pequeno Timmy.", timestamp: Date(), isFromCurrentUser: false),
                    Message(content: "Deixa eu ver.", timestamp: Date(), isFromCurrentUser: true, isRead: true),
                    Message(content: "Vou levar ele ao veterinário.", timestamp: Date(), isFromCurrentUser: true)
                ]
            ),
            Chat(
                id: Self.idTenis,
                userName: "Clube de Tênis",
                profileColor: "green",
                avatarURL: "https://testingbot.com/free-online-tools/random-avatar/202",
                lastMessage: "Ainda está de pé para amanhã?",
                lastMessageTime: "Ontem",
                unreadCount: 0,
                messages: [
                    Message(content: "Ainda está de pé para amanhã?", timestamp: Date(), isFromCurrentUser: false)
                ],
                isGroup: true,
                memberCount: 8
            ),
            Chat(
                id: Self.idJulia,
                userName: "Júlia, Jeff",
                profileColor: "blue",
                avatarURL: "https://testingbot.com/free-online-tools/random-avatar/103",
                lastMessage: "Espanha.jpg",
                lastMessageTime: "25 de mar",
                unreadCount: 99,
                messages: [
                    Message(content: "Espanha.jpg", timestamp: Date(), isFromCurrentUser: false)
                ],
                isGroup: true,
                memberCount: 3
            )
        ]

        for chat in chats {
            chatsDB[chat.id] = chat
        }
    }
}
