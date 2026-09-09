import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var controller: HabitController
    @State private var showingAddHabit = false

    private let calendar = Calendar.current
    private let weekLetters = ["S", "M", "T", "W", "T", "F", "S"]

    private var today: Date { Date() }

    private var dayName: String {
        today.formatted(.dateTime.weekday(.wide))
    }

    private var dateName: String {
        today.formatted(.dateTime.month(.abbreviated).day())
    }

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        header
                        progressCard
                            .padding(.bottom, 20)

                        SectionLabel(text: "Today's Habits")
                            .padding(.bottom, 12)

                        if controller.habits.isEmpty {
                            EmptyStateView()
                        } else {
                            LazyVStack(spacing: 12) {
                                ForEach(controller.habits) { habit in
                                    NavigationLink {
                                        HabitDetailView(habitID: habit.id)
                                    } label: {
                                        HabitRow(habit: habit)
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }

                        Spacer(minLength: 30)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showingAddHabit) {
                AddHabitView()
                    .environmentObject(controller)
                    .presentationDetents([.large])
            }
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 3) {
                SansText(dayName.uppercased(), size: 13, weight: .medium, color: AppColors.secondaryText)
                    .tracking(0.7)

                SerifText(dateName, size: 30)
            }

            Spacer()

            Button {
                showingAddHabit = true
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(AppColors.background)
                    .frame(width: 40, height: 40)
                    .background(AppColors.text)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 4)
        .padding(.bottom, 14)
    }

    private var progressCard: some View {
        let completed = controller.todayCompleted
        let total = controller.habits.count
        let message = completed == total && total > 0 ? "All done! 🎉" : completed == 0 ? "Let's begin" : "Keep going"
        let sub = completed == total && total > 0
            ? "You've completed all habits for today."
            : "\(max(total - completed, 0)) habit\(total - completed == 1 ? "" : "s") remaining today"

        return HStack(spacing: 18) {
            ZStack {
                CircularProgressView(value: completed, total: max(total, 1), size: 88)

                VStack(spacing: 1) {
                    SerifText("\(completed)", size: 22)
                    SansText("of \(total)", size: 11, color: AppColors.mutedText)
                }
            }

            VStack(alignment: .leading, spacing: 0) {
                SerifText(message, size: 19)
                    .padding(.bottom, 3)

                SansText(sub, size: 13, color: AppColors.secondaryText)
                    .lineLimit(2)

                HStack(spacing: 6) {
                    ForEach(0..<7, id: \.self) { index in
                        let isToday = index == calendar.component(.weekday, from: today) - 1
                        let isPast = index < calendar.component(.weekday, from: today) - 1

                        VStack(spacing: 4) {
                            SansText(weekLetters[index], size: 9, color: AppColors.mutedText)

                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(isToday ? AppColors.green : isPast ? AppColors.greenBackground : Color(red: 0.941, green: 0.929, blue: 0.914))
                                    .frame(width: 22, height: 22)

                                if isToday {
                                    SansText("\(calendar.component(.day, from: today))", size: 10, weight: .semibold, color: .white)
                                } else if isPast {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 9, weight: .bold))
                                        .foregroundStyle(AppColors.green)
                                }
                            }
                        }
                    }
                }
                .padding(.top, 10)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .habitCard()
    }
}

struct HabitRow: View {
    @EnvironmentObject private var controller: HabitController
    let habit: Habit

    var body: some View {
        HStack(spacing: 14) {
            Text(habit.icon)
                .font(.system(size: 22))
                .frame(width: 46, height: 46)
                .background(habit.colorBackground)
                .clipShape(RoundedRectangle(cornerRadius: 15))

            VStack(alignment: .leading, spacing: 3) {
                SansText(
                    habit.name,
                    size: 15,
                    weight: .semibold,
                    color: habit.completed ? AppColors.mutedText : AppColors.text
                )
                .strikethrough(habit.completed)

                HStack(spacing: 5) {
                    Text("🔥").font(.system(size: 10))
                    SansText("\(habit.streak) day streak", size: 12, color: AppColors.mutedText)
                }
            }

            Spacer()

            Button {
                controller.toggleHabit(habit.id)
            } label: {
                ZStack {
                    Circle()
                        .fill(habit.completed ? habit.color : .clear)
                        .frame(width: 28, height: 28)
                        .overlay(
                            Circle()
                                .stroke(habit.completed ? .clear : AppColors.border, lineWidth: 2)
                        )

                    if habit.completed {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .padding(15)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(habit.completed ? habit.colorBackground : .clear, lineWidth: 1.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.04), radius: 7, y: 1)
    }
}
