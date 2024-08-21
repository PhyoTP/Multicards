import SwiftUI

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
class UserData: ObservableObject{
    @AppStorage("isDone") var done = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("username") var name = "You"
}
