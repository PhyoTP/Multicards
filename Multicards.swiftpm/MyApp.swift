import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserManager())
                .environmentObject(LocalSetsManager())
                .environmentObject(SetsManager())
                .environmentObject(UserData())
        }
    }
}
class UserData: ObservableObject{
    @AppStorage("isDone") var done = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("username") var name = "You"
}
