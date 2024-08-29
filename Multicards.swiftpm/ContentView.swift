import SwiftUI
struct ContentView: View {
    @StateObject private var userData = UserData()
    @StateObject private var userManager = UserManager()
    @StateObject private var localSetsManager = LocalSetsManager()
    @State var selection = 2
    var body: some View {
        if userData.done {
            TabView(selection: $selection) {
                LibraryView(userData: userData)
                    .tabItem {
                        Label("Library", systemImage: "books.vertical.fill")
                    }.tag(1)
                    .environmentObject(userManager)
                    .environmentObject(localSetsManager)
                HomeView(userData: userData)
                    .tabItem {
                        Label("Home", systemImage: "house.fill")
                    }.tag(2)
                    .environmentObject(localSetsManager)
                SettingsView(userData: userData)
                    .tabItem {
                        Label("Settings", systemImage: "gear")
                            .symbolRenderingMode(.palette)
                    }.tag(3)
                    .environmentObject(localSetsManager)
                    .environmentObject(userManager)
            }
            .onAppear(){
                userManager.relogin()
                selection = 2
            }
        } else {
            StartView(userData: userData)
                .environmentObject(userManager)
        }
    }
}
