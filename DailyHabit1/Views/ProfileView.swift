import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var controller: HabitController
    @State private var showClearConfirmation = false

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    profileHeader
                    miniStats
                    achievements
                    settings

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
            }
        }
        .alert("Clear All Data?", isPresented: $showClearConfirmation) {
            Button("Cancel", role: .cancel) {}
            Button("Clear", role: .destructive) {
                controller.clearAllData()
            }
        } message: {
            Text("This will remove all current habits from the app.")
        }
    }

    private var profileHeader: some View {
        HStack(spacing: 18) {
            Text("🌿")
                .font(.system(size: 30))
                .frame(width: 68, height: 68)
                .background(
                    LinearGradient(
                        colors: [AppColors.greenBackground, Color(red: 0.816, green: 0.871, blue: 0.824)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))

            VStack(alignment: .leading, spacing: 2) {
                SerifText(controller.userName, size: 24)
                SansText("Building good habits since Sep 2024", size: 13, color: AppColors.secondaryText)

                HStack(spacing: 4) {
                    Text("🔥").font(.system(size: 12))
                    SansText("\(controller.bestStreak) day best streak", size: 13, weight: .semibold, color: AppColors.green)
                }
                .padding(.top, 1)
            }
        }
        .padding(.bottom, 20)
    }

    private var miniStats: some View {
        HStack {
            profileStat(value: "\(controller.habits.count)", label: "Habits")
            profileStat(value: "\(controller.totalCompleted)", label: "Done")
            profileStat(value: "\(controller.bestStreak)d", label: "Best")
        }
        .padding(.vertical, 18)
        .frame(maxWidth: .infinity)
        .background(AppColors.text)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .padding(.bottom, 22)
    }

    private func profileStat(value: String, label: String) -> some View {
        VStack(spacing: 2) {
            SerifText(value, size: 24, color: AppColors.background)
            SansText(label, size: 11, color: AppColors.mutedText)
        }
        .frame(maxWidth: .infinity)
    }

    private var achievements: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: "Achievements")

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                ForEach(controller.achievements) { achievement in
                    VStack(spacing: 5) {
                        Text(achievement.icon)
                            .font(.system(size: 26))

                        SansText(achievement.label, size: 11, weight: .semibold)
                        SansText(achievement.description, size: 10, color: AppColors.mutedText)
                            .multilineTextAlignment(.center)
                            .lineLimit(3)
                    }
                    .padding(.horizontal, 8)
                    .frame(maxWidth: .infinity, minHeight: 105)
                    .background(achievement.unlocked ? Color.white : Color(red: 0.941, green: 0.929, blue: 0.914))
                    .opacity(achievement.unlocked ? 1 : 0.5)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .shadow(color: achievement.unlocked ? .black.opacity(0.04) : .clear, radius: 7, y: 1)
                }
            }
        }
        .padding(.bottom, 22)
    }

    private var settings: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionLabel(text: "Settings")

            VStack(spacing: 0) {
                settingRow(icon: "🔔", title: "Reminders", value: "8:00 AM") {}
                Divider().padding(.leading, 50)

                settingRow(icon: "🌙", title: "Dark Mode", value: controller.isDarkMode ? "On" : "Off") {
                    controller.isDarkMode.toggle()
                }
                Divider().padding(.leading, 50)

                settingRow(icon: "📅", title: "Week Start", value: "Monday") {}
                Divider().padding(.leading, 50)

                settingRow(icon: "🗑️", title: "Clear All Data", value: "") {
                    showClearConfirmation = true
                }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.04), radius: 7, y: 1)
        }
    }

    private func settingRow(
        icon: String,
        title: String,
        value: String,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Text(icon).font(.system(size: 18))
                SansText(title, size: 15, color: title == "Clear All Data" ? Color(red: 0.77, green: 0.27, blue: 0.27) : AppColors.text)

                Spacer()

                if !value.isEmpty {
                    SansText(value, size: 14, color: AppColors.mutedText)
                    Image(systemName: "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Color(red: 0.75, green: 0.73, blue: 0.70))
                }
            }
            .padding(.horizontal, 18)
            .frame(height: 52)
        }
        .buttonStyle(.plain)
    }
}
