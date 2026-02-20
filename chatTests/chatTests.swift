//
//  chatTests.swift
//  chatTests
//
//  Created by Leonardo Lima on 19/02/26.
//

import Testing
import Foundation
@testable import chat

struct chatTests {

    @Test func messageIsCreatedWithCorrectContent() {
        let message = Message(
            id: "1",
            content: "Olá!",
            timestamp: Date(),
            isFromCurrentUser: true
        )
        #expect(message.content == "Olá!")
        #expect(message.isFromCurrentUser == true)
        #expect(message.isRead == false)
    }

    @Test func messageDefaultIdIsGenerated() {
        let message = Message(
            content: "Teste",
            timestamp: Date(),
            isFromCurrentUser: false
        )
        #expect(!message.id.isEmpty)
    }

    @Test func chatIsCreatedWithCorrectFields() {
        let chat = Chat(
            id: "chat-1",
            userName: "Leonardo",
            profileColor: "#FF0000",
            lastMessage: "Oi!",
            lastMessageTime: "10:00",
            unreadCount: 2,
            messages: []
        )
        #expect(chat.userName == "Leonardo")
        #expect(chat.unreadCount == 2)
        #expect(chat.isGroup == false)
    }

    @Test func chatGroupFlagIsRespected() {
        let groupChat = Chat(
            id: "group-1",
            userName: "Grupo Dev",
            profileColor: "#00FF00",
            lastMessage: "Bem-vindos!",
            lastMessageTime: "09:00",
            unreadCount: 5,
            messages: [],
            isGroup: true,
            memberCount: 10
        )
        #expect(groupChat.isGroup == true)
        #expect(groupChat.memberCount == 10)
    }
}
