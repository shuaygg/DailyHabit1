import SwiftUI

@main
struct DailyHabitsApp: App {
    @StateObject private var controller = HabitController()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(controller)
        }
    }
}

struct RootView: View {
    @EnvironmentObject private var controller: HabitController

    var body: some View {
        Group {
            if controller.hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .preferredColorScheme(controller.isDarkMode ? .dark : .light)
    }
}
