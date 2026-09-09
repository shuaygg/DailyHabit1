import SwiftUI

struct HabitDetailView: View {
    @EnvironmentObject private var controller: HabitController
    @Environment(\.dismiss) private var dismiss

    let habitID: UUID

    private var habit: Habit? {
        controller.habits.first { $0.id == habitID }
    }

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            if let habit {
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            BackButton { dismiss() }
                            Spacer()
                        }
                        .padding(.bottom, 12)

                        hero(habit)
                        stats(habit)
                        heatmap(habit)
                        streakCard(habit)

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                }
            } else {
                EmptyStateView()
            }
        }
        .navigationBarHidden(true)
    }

    private func hero(_ habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Text(habit.icon)
                    .font(.system(size: 28))
                    .frame(width: 56, height: 56)
                    .background(.white.opacity(0.7))
                    .clipShape(RoundedRectangle(cornerRadius: 18))

                Spacer()

                Button {
                    controller.toggleHabit(habit.id)
                } label: {
                    Text(habit.completed ? "Done ✓" : "Mark done")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(habit.completed ? .white : habit.color)
                        .padding(.horizontal, 16)
                        .frame(height: 36)
                        .background(habit.completed ? habit.color : .white.opacity(0.8))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            }

            SerifText(habit.name, size: 26)
                .padding(.top, 18)

            SansText("\(habit.category) · Daily", size: 13, color: AppColors.secondaryText)
                .padding(.top, 2)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(habit.colorBackground)
        .clipShape(RoundedRectangle(cornerRadius: 24))
        .padding(.bottom, 14)
    }

    private func stats(_ habit: Habit) -> some View {
        let completed = habit.completedDays.filter { $0 }.count
        let completion = Int((Double(completed) / 30.0 * 100).rounded())

        return HStack(spacing: 10) {
            detailStat(value: "\(habit.streak)", unit: "days", label: "Current Streak")
            detailStat(value: "\(completion)", unit: "%", label: "Completion")
            detailStat(value: "\(habit.streak + 3)", unit: "days", label: "Best Streak")
        }
        .padding(.bottom, 14)
    }

    private func detailStat(value: String, unit: String, label: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline, spacing: 2) {
                SerifText(value, size: 22)
                SansText(unit, size: 12, color: AppColors.secondaryText)
            }
            SansText(label, size: 11, color: AppColors.mutedText)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 18))
        .shadow(color: .black.opacity(0.04), radius: 7, y: 1)
    }

    private func heatmap(_ habit: Habit) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            SectionLabel(text: "Last 30 Days")
                .padding(.bottom, 12)

            HStack(spacing: 0) {
                ForEach(["M", "T", "W", "T", "F", "S", "S"], id: \.self) { day in
                    SansText(day, size: 10, color: Color(red: 0.75, green: 0.73, blue: 0.70))
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 6)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 5), count: 7), spacing: 5) {
                ForEach(Array(habit.completedDays.prefix(30).enumerated()), id: \.offset) { _, done in
                    RoundedRectangle(cornerRadius: 7)
                        .fill(done ? habit.color : Color(red: 0.941, green: 0.929, blue: 0.914))
                        .opacity(done ? 1 : 0.5)
                        .aspectRatio(1, contentMode: .fit)
                }
            }

            HStack(spacing: 7) {
                RoundedRectangle(cornerRadius: 3)
                    .fill(Color(red: 0.941, green: 0.929, blue: 0.914))
                    .frame(width: 10, height: 10)
                SansText("Missed", size: 11, color: AppColors.mutedText)

                RoundedRectangle(cornerRadius: 3)
                    .fill(habit.color)
                    .frame(width: 10, height: 10)
                    .padding(.leading, 5)
                SansText("Done", size: 11, color: AppColors.mutedText)
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            .padding(.top, 12)
        }
        .padding(18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 7, y: 1)
        .padding(.bottom, 14)
    }

    private func streakCard(_ habit: Habit) -> some View {
        HStack(spacing: 16) {
            Text("🔥")
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: 2) {
                SerifText("\(habit.streak)-day streak!", size: 20, color: AppColors.background)
                SansText("Keep going — you're building momentum.", size: 13, color: AppColors.mutedText)
            }

            Spacer()
        }
        .padding(.horizontal, 20)
        .frame(minHeight: 76)
        .background(AppColors.text)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}
