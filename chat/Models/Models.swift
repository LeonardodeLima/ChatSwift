import Foundation

struct Message: Identifiable {
    let id: String
    let content: String
    let timestamp: Date
    let isFromCurrentUser: Bool
    var isRead: Bool = false

    init(id: String = String(Int.random(in: 100000...999999)), content: String, timestamp: Date, isFromCurrentUser: Bool, isRead: Bool = false) {
        self.id = id
        self.content = content
        self.timestamp = timestamp
        self.isFromCurrentUser = isFromCurrentUser
        self.isRead = isRead
    }
}

struct Chat: Identifiable {
    let id: String
    let userName: String
    let profileColor: String
    let avatarURL: String?
    let lastMessage: String
    let lastMessageTime: String
    let unreadCount: Int
    var messages: [Message]
    var isGroup: Bool = false
    var memberCount: Int? = nil

    init(id: String, userName: String, profileColor: String, avatarURL: String? = nil,
         lastMessage: String, lastMessageTime: String, unreadCount: Int,
         messages: [Message], isGroup: Bool = false, memberCount: Int? = nil) {
        self.id = id
        self.userName = userName
        self.profileColor = profileColor
        self.avatarURL = avatarURL
        self.lastMessage = lastMessage
        self.lastMessageTime = lastMessageTime
        self.unreadCount = unreadCount
        self.messages = messages
        self.isGroup = isGroup
        self.memberCount = memberCount
    }
}
