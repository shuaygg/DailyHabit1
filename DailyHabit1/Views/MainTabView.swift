import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Today", systemImage: "square.grid.2x2")
                }

            ProgressViewScreen()
                .tabItem {
                    Label("Progress", systemImage: "chart.xyaxis.line")
                }

            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person")
                }
        }
        .tint(AppColors.green)
    }
}
