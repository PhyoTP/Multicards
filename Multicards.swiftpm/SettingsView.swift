import SwiftUI

struct SettingsView: View{
    var userData: UserData
    @State private var showAlert = false
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @State private var login = false
    @State private var register = false
    var body: some View{
        NavigationStack{
            Form{
                Section("phyo id"){
                    if userData.isLoggedIn{
                        
                        Text("Logged in as "+userData.name)
                        Button("Log out",role: .destructive){
                            showAlert = true
                        }
                        
                    }else{
                        
                        Button("Log in"){
                            login = true
                        }
                        Button("Register"){
                            register = true
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
                userData.name = "You"
                deleteToken()
                localSetsManager.localSets = []
                userManager.user = User(username: "", password: "")
            }
        }
        .sheet(isPresented: $login, content: {
            LoginView(userData: userData)
                .environmentObject(userManager)
        })
        .sheet(isPresented: $register, content: {
            RegisterView(userData: userData) 
                .environmentObject(userManager)
        })
    }
}
