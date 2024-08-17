import SwiftUI

struct ContentView: View {
    @StateObject private var userData = UserData()
    var body: some View {
        if userData.done{
            TabView{
                HomeView()
                    .tabItem { 
                        Label("Home", systemImage: "house.fill")
                    }
                LibraryView()
                    .tabItem { 
                        Label("Library", systemImage: "books.vertical.fill")
                    }
            }
        }else{
            StartView(userData: userData)
        }
    }
}
