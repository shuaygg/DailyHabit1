import SwiftUI
import Combine
import Foundation

@MainActor
final class HabitController: ObservableObject {
    @Published var habits: [Habit]
    @Published var selectedHabit: Habit?
    @Published var userName = "Alex Chen"
    @Published var hasCompletedOnboarding = false
    @Published var isDarkMode = false

    init() {
        self.habits = Self.loadHabits() ?? Self.defaultHabits
    }

    static let categories = ["Mindfulness", "Fitness", "Health", "Learning", "Creativity", "Social"]

    static let categoryIcons: [String: String] = [
        "Mindfulness": "🧘",
        "Fitness": "🏃",
        "Health": "💧",
        "Learning": "📖",
        "Creativity": "🎨",
        "Social": "👥"
    ]

    static let categoryColors: [String: (Color, Color)] = [
        "Mindfulness": (AppColors.green, AppColors.greenBackground),
        "Fitness": (AppColors.purple, AppColors.purpleBackground),
        "Health": (AppColors.blue, AppColors.blueBackground),
        "Learning": (AppColors.brown, AppColors.brownBackground),
        "Creativity": (Color(red: 0.69, green: 0.35, blue: 0.48), Color(red: 0.96, green: 0.87, blue: 0.91)),
        "Social": (Color(red: 0.48, green: 0.56, blue: 0.36), Color(red: 0.91, green: 0.93, blue: 0.88))
    ]

    private func saveHabits() {
        let dtos = habits.map { HabitDTO(id: $0.id, name: $0.name, icon: $0.icon, streak: $0.streak, completed: $0.completed, category: $0.category, completedDays: $0.completedDays) }
        if let encoded = try? JSONEncoder().encode(dtos) {
            UserDefaults.standard.set(encoded, forKey: "habits")
        }
    }

    private static func loadHabits() -> [Habit]? {
        guard let data = UserDefaults.standard.data(forKey: "habits"),
              let dtos = try? JSONDecoder().decode([HabitDTO].self, from: data) else {
            return nil
        }
        return dtos.map { dto in
            let colors = categoryColors[dto.category] ?? (AppColors.green, AppColors.greenBackground)
            return Habit(id: dto.id, name: dto.name, icon: dto.icon, color: colors.0, colorBackground: colors.1, streak: dto.streak, completed: dto.completed, category: dto.category, completedDays: dto.completedDays)
        }
    }

    func finishOnboarding(name: String) {
        if !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            userName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        hasCompletedOnboarding = true
    }

    func toggleHabit(_ id: UUID) {
        guard let index = habits.firstIndex(where: { $0.id == id }) else { return }

        let wasCompleted = habits[index].completed
        habits[index].completed.toggle()

        if !wasCompleted {
            habits[index].streak += 1
        } else {
            habits[index].streak = max(habits[index].streak - 1, 0)
        }

        if selectedHabit?.id == id {
            selectedHabit = habits[index]
        }
        saveHabits()
    }

    func selectHabit(_ habit: Habit) {
        selectedHabit = habit
    }

    func addHabit(name: String, category: String, icon: String) {
        guard !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }

        let colors = HabitController.categoryColors[category] ?? (AppColors.green, AppColors.greenBackground)

        let newHabit = Habit(
            name: name.trimmingCharacters(in: .whitespacesAndNewlines),
            icon: icon,
            color: colors.0,
            colorBackground: colors.1,
            streak: 0,
            completed: false,
            category: category,
            completedDays: Array(repeating: false, count: 30)
        )

        habits.append(newHabit)
        saveHabits()
    }

    func clearAllData() {
        habits = []
        selectedHabit = nil
        UserDefaults.standard.removeObject(forKey: "habits")
    }

    var totalCompleted: Int {
        habits.reduce(0) { $0 + $1.completedDays.filter { $0 }.count }
    }

    var bestStreak: Int {
        habits.map(\.streak).max() ?? 0
    }

    var todayCompleted: Int {
        habits.filter(\.completed).count
    }

    var averageRate: Int {
        guard !habits.isEmpty else { return 0 }
        return Int((Double(totalCompleted) / Double(habits.count * 30) * 100).rounded())
    }

    var achievements: [Achievement] {
        [
            Achievement(icon: "🌱", label: "First Habit", description: "Created your first habit", unlocked: !habits.isEmpty),
            Achievement(icon: "🔥", label: "On Fire", description: "7-day streak on any habit", unlocked: habits.contains { $0.streak >= 7 }),
            Achievement(icon: "💯", label: "Perfect Day", description: "Complete all habits in a day", unlocked: !habits.isEmpty && habits.allSatisfy(\.completed)),
            Achievement(icon: "🏆", label: "Month Master", description: "30-day streak on any habit", unlocked: habits.contains { $0.streak >= 30 }),
            Achievement(icon: "⭐", label: "Five Habits", description: "Track 5 habits at once", unlocked: habits.count >= 5),
            Achievement(icon: "🌟", label: "Century", description: "100 total completions", unlocked: totalCompleted >= 100)
        ]
    }

    static let defaultHabits: [Habit] = [
        Habit(
            name: "Morning Meditation", icon: "🧘",
            color: AppColors.green, colorBackground: AppColors.greenBackground,
            streak: 12, completed: true, category: "Mindfulness",
            completedDays: [true,true,true,false,true,true,true,true,false,true,true,true,false,true,false,true,true,true,false,true,true,true,false,false,true,true,true,false,true,true]
        ),
        Habit(
            name: "Read 30 Minutes", icon: "📖",
            color: AppColors.brown, colorBackground: AppColors.brownBackground,
            streak: 7, completed: false, category: "Learning",
            completedDays: [false,true,true,false,true,true,false,true,false,true,true,false,false,true,false,true,true,false,false,true,true,false,false,false,true,true,false,false,true,false]
        ),
        Habit(
            name: "Drink 8 Glasses", icon: "💧",
            color: AppColors.blue, colorBackground: AppColors.blueBackground,
            streak: 21, completed: true, category: "Health",
            completedDays: [true,true,true,true,true,false,true,true,true,true,true,true,true,false,true,true,true,true,false,true,true,true,true,true,false,true,true,true,true,true]
        ),
        Habit(
            name: "Evening Walk", icon: "🚶",
            color: AppColors.purple, colorBackground: AppColors.purpleBackground,
            streak: 5, completed: false, category: "Fitness",
            completedDays: [false,false,true,false,false,true,false,false,false,true,true,false,false,false,true,false,false,true,false,false,false,true,false,false,true,false,false,false,false,true]
        ),
        Habit(
            name: "Journaling", icon: "✏️",
            color: AppColors.orange, colorBackground: AppColors.orangeBackground,
            streak: 3, completed: true, category: "Mindfulness",
            completedDays: [true,false,false,true,false,false,true,false,false,false,true,false,false,true,false,false,false,true,false,false,true,false,false,false,false,true,false,false,true,false]
        )
    ]
}
