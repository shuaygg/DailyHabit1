import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var controller: HabitController
    @State private var name = ""
    @State private var step = 0

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Spacer()
                    Text("9:41")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(AppColors.text)
                    Spacer()
                }
                .padding(.top, 8)

                if step == 0 {
                    welcomeStep
                } else {
                    nameStep
                }
            }
        }
    }

    private var welcomeStep: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            Text("🌿")
                .font(.system(size: 40))
                .frame(width: 80, height: 80)
                .background(
                    LinearGradient(
                        colors: [AppColors.greenBackground, Color(red: 0.816, green: 0.871, blue: 0.824)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .clipShape(RoundedRectangle(cornerRadius: 24))
                .padding(.bottom, 30)

            SerifText("Build habits", size: 38)
            SerifText("that last.", size: 38, italic: true)
                .padding(.bottom, 12)

            SansText(
                "Track your daily rituals. Stay consistent. Watch yourself grow — one small habit at a time.",
                size: 16,
                color: AppColors.secondaryText
            )
            .lineSpacing(5)
            .frame(maxWidth: 290, alignment: .leading)

            HStack(spacing: 12) {
                ForEach(["🧘", "💧", "📖", "🏃"], id: \.self) { emoji in
                    Text(emoji)
                        .font(.system(size: 24))
                        .frame(width: 52, height: 52)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(color: .black.opacity(0.07), radius: 7, y: 2)
                }
            }
            .padding(.top, 26)

            Spacer()

            Button {
                withAnimation(.easeInOut) {
                    step = 1
                }
            } label: {
                Text("Get started")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(AppColors.background)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(AppColors.text)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)

            SansText("Free to use · No account needed", size: 13, color: AppColors.mutedText)
                .frame(maxWidth: .infinity)
                .padding(.top, 12)
                .padding(.bottom, 10)
        }
        .padding(.horizontal, 32)
    }

    private var nameStep: some View {
        VStack(alignment: .leading, spacing: 0) {
            Spacer()

            SerifText("What should we", size: 32)
            SerifText("call you?", size: 32)
                .padding(.bottom, 8)

            SansText("We'll use this to personalize your experience.", size: 15, color: AppColors.secondaryText)
                .padding(.bottom, 28)

            TextField("Your name", text: $name)
                .font(.system(size: 17))
                .padding(.horizontal, 20)
                .frame(height: 56)
                .background(Color.white)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(name.isEmpty ? AppColors.border : AppColors.green, lineWidth: 1.5)
                )
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Spacer()

            Button {
                controller.finishOnboarding(name: name)
            } label: {
                Text("Continue")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.mutedText : AppColors.background)
                    .frame(maxWidth: .infinity)
                    .frame(height: 56)
                    .background(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? AppColors.border : AppColors.text)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .disabled(name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            .buttonStyle(.plain)
            .padding(.bottom, 12)
        }
        .padding(.horizontal, 32)
    }
}
