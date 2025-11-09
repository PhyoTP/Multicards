import SwiftUI
let accent: Color = Color(red: 228/255, green: 148/255, blue: 27/255)
let bg: Color = Color(red: 0.231373, green: 0.141176, blue: 0)
let back: Color = Color(red: 0.36078, green: 0.21569, blue: 0.039216)
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
                .preferredColorScheme(.dark)
        }
    }
}
class UserData: ObservableObject{
    @AppStorage("isDone") var done = false
    @AppStorage("isLoggedIn") var isLoggedIn = false
    @AppStorage("username") var name = "You"
}
