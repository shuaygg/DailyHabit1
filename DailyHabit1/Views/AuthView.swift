import SwiftUI

struct AuthView: View {
    @EnvironmentObject private var controller: HabitController
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            VStack(alignment: .leading, spacing: 20) {
                Spacer()

                SerifText(isLogin ? "Welcome back" : "Create account", size: 32)
                    .padding(.bottom, 8)

                SansText(isLogin ? "Log in to continue your journey." : "Sign up to start tracking your habits.", size: 15, color: AppColors.secondaryText)
                    .padding(.bottom, 28)

                VStack(spacing: 16) {
                    TextField("Email", text: $email)
                        .font(.system(size: 17))
                        .padding(.horizontal, 20)
                        .frame(height: 56)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.border, lineWidth: 1.5))

                    SecureField("Password", text: $password)
                        .font(.system(size: 17))
                        .padding(.horizontal, 20)
                        .frame(height: 56)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(AppColors.border, lineWidth: 1.5))
                }

                Button {
                    controller.authenticate(email: email, password: password, isLogin: isLogin) { success in
                        if success && !isLogin {
                            isLogin = true // Switch to login after registration
                        }
                    }
                } label: {
                    Text(isLogin ? "Log In" : "Register")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(AppColors.background)
                        .frame(maxWidth: .infinity)
                        .frame(height: 56)
                        .background(AppColors.text)
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                }
                .buttonStyle(.plain)
                .padding(.top, 10)

                Button {
                    isLogin.toggle()
                } label: {
                    SansText(isLogin ? "Don't have an account? Register" : "Already have an account? Log in", size: 14, color: AppColors.blue)
                        .frame(maxWidth: .infinity)
                }

                Spacer()
            }
            .padding(.horizontal, 32)
        }
    }
}
