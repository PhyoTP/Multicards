import SwiftUI

struct ContentView: View {
    @StateObject private var userData = UserData()
    @StateObject var userManager = UserManager()
    @State var selection = 2
    var body: some View {
        if userData.done{
            TabView(selection: $selection){
                LibraryView(userData: userData)
                    .tabItem { 
                        Label("Library", systemImage: "books.vertical.fill")
                    }.tag(1)
                HomeView(userData: userData)
                    .tabItem { 
                        Label("Home", systemImage: "house.fill")
                    }.tag(2)
                SettingsView()
                    .tabItem { 
                        Label("Settings", systemImage: "gear")
                    }.tag(3)
            }
        }else{
            StartView(userData: userData, userManager: userManager)
        }
    }
}
