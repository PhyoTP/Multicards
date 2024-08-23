import SwiftUI

struct SettingsView: View{
    var userData: UserData
    @State var showAlert = false
    var body: some View{
        NavigationStack{
            Form{
                if userData.isLoggedIn{
                    Section("user info"){
                        Text("Logged in as "+userData.name)
                        Button("Log out",role: .destructive){
                            showAlert = true
                        }
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .alert("Are you sure you want to log out?", isPresented: $showAlert){
            Button("Log out",role: .destructive){
                userData.done = false
                userData.isLoggedIn = false
                userData.name = ""
                deleteToken()
            }
        }
    }
}
