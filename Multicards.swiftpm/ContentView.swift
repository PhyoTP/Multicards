import SwiftUI
struct ContentView: View {
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var userManager: UserManager
    @State private var selection = 2
    init() {
        let appearance = UINavigationBarAppearance()
        appearance.largeTitleTextAttributes = [
            .font : UIFont(name: "AvenirNext-bold", size: 34)!
        ]
        appearance.titleTextAttributes = [
            .font : UIFont(name: "AvenirNext-bold", size: 18)!
        ]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
    }
    var body: some View {
        VStack{
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
}
