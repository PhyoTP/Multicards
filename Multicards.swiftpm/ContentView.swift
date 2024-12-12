import SwiftUI
struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var userManager: UserManager
    @State private var selection = 2
    var body: some View {
        if userData.done {
            TabView(selection: $selection) {
                LibraryView()
                    .tabItem {
                        Label("Library", systemImage: "books.vertical.fill")
                    }.tag(1)
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }.tag(2)
                SettingsView()
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                    }.tag(3)
            }
            .onAppear(){
                userManager.relogin()
                selection = 2
            }
        } else {
            StartView()
        }
    }
}
