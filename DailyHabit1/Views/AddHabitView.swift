import SwiftUI

struct AddHabitView: View {
    @EnvironmentObject private var controller: HabitController
    @Environment(\.dismiss) private var dismiss

    @State private var name = ""
    @State private var selectedCategory = "Mindfulness"
    @State private var selectedIcon = "🧘"

    private let emojiOptions = ["🧘", "💧", "📖", "🏃", "🎨", "✏️", "🍎", "😴", "🧹", "🎯", "💪", "🌅"]

    var body: some View {
        NavigationStack {
            ZStack {
                AppColors.background.ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            BackButton { dismiss() }
                            SerifText("New Habit", size: 24)
                                .padding(.leading, 2)
                            Spacer()
                        }
                        .padding(.bottom, 28)

                        SectionLabel(text: "Habit Name")
                            .padding(.bottom, 8)

                        TextField("e.g. Morning Meditation", text: $name)
                            .font(.system(size: 16))
                            .padding(.horizontal, 18)
                            .frame(height: 52)
                            .background(Color.white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(name.isEmpty ? AppColors.border : AppColors.green, lineWidth: 1.5)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .padding(.bottom, 22)

                        SectionLabel(text: "Icon")
                            .padding(.bottom, 8)

                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 8), count: 6), spacing: 8) {
                            ForEach(emojiOptions, id: \.self) { emoji in
                                Button {
                                    selectedIcon = emoji
                                } label: {
                                    Text(emoji)
                                        .font(.system(size: 22))
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 48)
                                        .background(selectedIcon == emoji ? AppColors.greenBackground : Color.white)
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 14)
                                                .stroke(selectedIcon == emoji ? AppColors.green : AppColors.border, lineWidth: selectedIcon == emoji ? 2 : 1.5)
                                        )
                                        .clipShape(RoundedRectangle(cornerRadius: 14))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.bottom, 22)

                        SectionLabel(text: "Category")
                            .padding(.bottom, 8)

                        VStack(spacing: 8) {
                            ForEach(controller.categories, id: \.self) { category in
                                categoryRow(category)
                            }
                        }

                        Button {
                            controller.addHabit(name: name, category: selectedCategory, icon: selectedIcon)
                            dismiss()
                        } label: {
                            Text("Add Habit")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.mutedText : AppColors.background)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.border : AppColors.text)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                        }
                        .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                        .buttonStyle(.plain)
                        .padding(.top, 28)
                    }
                    .padding(.horizontal, 24)
                    .padding(.top, 8)
                    .padding(.bottom, 30)
                }
            }
            .navigationBarHidden(true)
        }
    }

    private func categoryRow(_ category: String) -> some View {
        let colors = controller.categoryColors[category] ?? (AppColors.green, AppColors.greenBackground)
        let selected = selectedCategory == category

        return Button {
            selectedCategory = category
        } label: {
            HStack(spacing: 14) {
                Text(controller.categoryIcons[category] ?? "🌿")
                    .font(.system(size: 20))

                SansText(category, size: 15, weight: .medium, color: selected ? colors.0 : AppColors.text)

                Spacer()

                if selected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(colors.0)
                }
            }
            .padding(.horizontal, 16)
            .frame(height: 52)
            .background(selected ? colors.1 : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(selected ? colors.0 : AppColors.border, lineWidth: 1.5)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}
