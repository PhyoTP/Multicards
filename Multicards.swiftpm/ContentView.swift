import SwiftUI

struct ContentView: View {
    @StateObject private var userData = UserData()
    @StateObject var userManager = UserManager()
    var body: some View {
        if userData.done{
            TabView{
                HomeView(userData: userData)
                    .tabItem { 
                        Label("Home", systemImage: "house.fill")
                    }
                LibraryView()
                    .tabItem { 
                        Label("Library", systemImage: "books.vertical.fill")
                    }
            }
        }else{
            StartView(userData: userData, userManager: userManager)
        }
    }
}
