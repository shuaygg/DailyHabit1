import SwiftUI

enum AppColors {
    static let background = Color(red: 0.969, green: 0.961, blue: 0.949)
    static let text = Color(red: 0.110, green: 0.102, blue: 0.094)
    static let secondaryText = Color(red: 0.478, green: 0.459, blue: 0.439)
    static let mutedText = Color(red: 0.690, green: 0.667, blue: 0.624)
    static let border = Color(red: 0.910, green: 0.894, blue: 0.875)

    static let green = Color(red: 0.357, green: 0.482, blue: 0.373)
    static let greenBackground = Color(red: 0.894, green: 0.929, blue: 0.898)

    static let brown = Color(red: 0.690, green: 0.478, blue: 0.361)
    static let brownBackground = Color(red: 0.941, green: 0.898, blue: 0.863)

    static let blue = Color(red: 0.290, green: 0.498, blue: 0.647)
    static let blueBackground = Color(red: 0.859, green: 0.933, blue: 0.969)

    static let purple = Color(red: 0.482, green: 0.369, blue: 0.655)
    static let purpleBackground = Color(red: 0.925, green: 0.898, blue: 0.961)

    static let orange = Color(red: 0.627, green: 0.392, blue: 0.235)
    static let orangeBackground = Color(red: 0.961, green: 0.910, blue: 0.863)
}

struct CardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

extension View {
    func habitCard() -> some View {
        modifier(CardModifier())
    }
}

struct SerifText: View {
    let text: String
    let size: CGFloat
    let color: Color
    let italic: Bool

    init(_ text: String, size: CGFloat, color: Color = AppColors.text, italic: Bool = false) {
        self.text = text
        self.size = size
        self.color = color
        self.italic = italic
    }

    var body: some View {
        Text(text)
            .font(.system(size: size, weight: .regular, design: .serif))
            .italic(italic)
            .foregroundStyle(color)
    }
}

struct SansText: View {
    let text: String
    let size: CGFloat
    let weight: Font.Weight
    let color: Color

    init(_ text: String, size: CGFloat, weight: Font.Weight = .regular, color: Color = AppColors.text) {
        self.text = text
        self.size = size
        self.weight = weight
        self.color = color
    }

    var body: some View {
        Text(text)
            .font(.system(size: size, weight: weight, design: .rounded))
            .foregroundStyle(color)
    }
}

struct SectionLabel: View {
    let text: String

    var body: some View {
        SansText(text.uppercased(), size: 12, weight: .semibold, color: AppColors.secondaryText)
            .tracking(1)
    }
}

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppColors.text)
                .frame(width: 36, height: 36)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .shadow(color: .black.opacity(0.06), radius: 6, y: 1)
        }
        .buttonStyle(.plain)
    }
}

struct CircularProgressView: View {
    let value: Int
    let total: Int
    var size: CGFloat = 88

    private var progress: Double {
        total == 0 ? 0 : min(Double(value) / Double(total), 1)
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(AppColors.border, lineWidth: 10)

            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    AppColors.green,
                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 0.4), value: progress)
        }
        .frame(width: size, height: size)
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("🌱").font(.system(size: 38))
            SerifText("Start your first habit", size: 21)
            SansText("Add a habit to begin tracking your progress.", size: 13, color: AppColors.secondaryText)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(30)
    }
}
