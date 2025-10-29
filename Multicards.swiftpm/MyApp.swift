import SwiftUI
let accent: Color = Color(red: 228/255, green: 148/255, blue: 27/255)
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
                .tint(accent)
        }
    }
}
class UserData: ObservableObject{
    @AppStorage("isDone") var done = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("username") var name = "You"
}
