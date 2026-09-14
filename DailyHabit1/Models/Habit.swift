import SwiftUI

struct Habit: Identifiable, Equatable {
    let id: UUID
    var name: String
    var icon: String
    var color: Color
    var colorBackground: Color
    var streak: Int
    var completed: Bool
    var category: String
    var completedDays: [Bool]

    init(
        id: UUID = UUID(),
        name: String,
        icon: String,
        color: Color,
        colorBackground: Color,
        streak: Int,
        completed: Bool,
        category: String,
        completedDays: [Bool]
    ) {
        self.id = id
        self.name = name
        self.icon = icon
        self.color = color
        self.colorBackground = colorBackground
        self.streak = streak
        self.completed = completed
        self.category = category
        self.completedDays = completedDays
    }
}

struct HabitDTO: Codable {
    let id: UUID
    let name: String
    let icon: String
    let streak: Int
    let completed: Bool
    let category: String
    let completedDays: [Bool]
}

struct Achievement: Identifiable {
    let id = UUID()
    let icon: String
    let label: String
    let description: String
    let unlocked: Bool
}
