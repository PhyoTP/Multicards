import SwiftUI

@main
struct MyApp: App {
    @State var recentSetManager = RecentSetManager()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(UserManager())
                .environmentObject(LocalSetsManager())
                .environmentObject(SetsManager())
                .environmentObject(UserData())
                .environment(recentSetManager)
        }
    }
}
class UserData: ObservableObject{
    @AppStorage("isDone") var done = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("username") var name = "You"
}
