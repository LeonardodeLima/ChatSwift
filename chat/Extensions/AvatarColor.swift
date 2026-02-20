import SwiftUI

extension Color {
    static func avatarColor(_ name: String) -> Color {
        switch name {
        case "purple": return Color("AvatarPurple")
        case "orange": return Color("AvatarOrange")
        case "green":  return Color("AvatarGreen")
        case "blue":   return Color("AvatarBlue")
        default:       return Color("AvatarPurple")
        }
    }
}
