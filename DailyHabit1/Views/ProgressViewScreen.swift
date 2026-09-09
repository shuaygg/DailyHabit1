import SwiftUI

struct ProgressViewScreen: View {
    @EnvironmentObject private var controller: HabitController

    private let weekData: [(String, Double)] = [
        ("Mon", 0.80), ("Tue", 0.60), ("Wed", 1.00),
        ("Thu", 0.70), ("Fri", 0.90), ("Sat", 0.50), ("Sun", 0.75)
    ]

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 0) {
                    SerifText("Progress", size: 30)
                    SansText("Your journey at a glance", size: 14, color: AppColors.secondaryText)
                        .padding(.top, 2)
                        .padding(.bottom, 18)

                    keyStats
                    weeklyChart
                    habitBreakdown

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 24)
                .padding(.top, 12)
            }
        }
    }

    private var keyStats: some View {
        let todayRate = controller.habits.isEmpty ? 0 : Int((Double(controller.todayCompleted) / Double(controller.habits.count) * 100).rounded())

        return LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
            progressStat(
                label: "Today's Rate",
                value: "\(todayRate)%",
                sub: "\(controller.todayCompleted)/\(controller.habits.count) habits",
                background: AppColors.text,
                foreground: AppColors.background,
                subForeground: AppColors.mutedText
            )

            progressStat(
                label: "30-Day Average",
                value: "\(controller.averageRate)%",
                sub: "completion rate",
                background: .white,
                foreground: AppColors.text,
                subForeground: AppColors.secondaryText
            )

            progressStat(
                label: "Best Streak",
                value: "\(controller.bestStreak) days",
                sub: "personal record",
                background: .white,
                foreground: AppColors.text,
                subForeground: AppColors.secondaryText
            )

            progressStat(
                label: "Total Checks",
                value: "\(controller.totalCompleted)",
                sub: "all time",
                background: AppColors.greenBackground,
                foreground: AppColors.text,
                subForeground: AppColors.green
            )
        }
        .padding(.bottom, 14)
    }

    private func progressStat(
        label: String,
        value: String,
        sub: String,
        background: Color,
        foreground: Color,
        subForeground: Color
    ) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SansText(label.uppercased(), size: 11, weight: .semibold, color: subForeground)
                .tracking(0.6)
                .padding(.bottom, 6)

            SerifText(value, size: 26, color: foreground)

            SansText(sub, size: 12, color: subForeground)
                .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, minHeight: 92, alignment: .leading)
        .padding(.horizontal, 16)
        .background(background)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 7, y: 1)
    }

    private var weeklyChart: some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionLabel(text: "This Week")
                .padding(.bottom, 16)

            HStack(alignment: .bottom, spacing: 9) {
                ForEach(Array(weekData.enumerated()), id: \.offset) { index, item in
                    VStack(spacing: 5) {
                        Spacer(minLength: 0)

                        RoundedRectangle(cornerRadius: 8)
                            .fill(index == 3 ? AppColors.green : AppColors.greenBackground)
                            .frame(height: CGFloat(item.1) * 64)

                        SansText(
                            item.0,
                            size: 10,
                            weight: index == 3 ? .bold : .regular,
                            color: index == 3 ? AppColors.green : AppColors.mutedText
                        )
                    }
                    .frame(maxWidth: .infinity, maxHeight: 80)
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 7, y: 1)
        .padding(.bottom, 14)
    }

    private var habitBreakdown: some View {
        VStack(alignment: .leading, spacing: 16) {
            SectionLabel(text: "Habit Streaks")

            ForEach(controller.habits) { habit in
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        HStack(spacing: 8) {
                            Text(habit.icon).font(.system(size: 15))
                            SansText(habit.name, size: 14, weight: .medium)
                        }

                        Spacer()

                        SansText("\(habit.streak)d", size: 13, weight: .semibold, color: AppColors.secondaryText)
                    }

                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule()
                                .fill(Color(red: 0.941, green: 0.929, blue: 0.914))

                            Capsule()
                                .fill(habit.color)
                                .frame(width: proxy.size.width * min(CGFloat(habit.streak) / 30, 1))
                        }
                    }
                    .frame(height: 6)
                }
            }
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 7, y: 1)
    }
}
