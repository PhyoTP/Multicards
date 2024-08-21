import SwiftUI

struct LoginView: View{
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    var userData: UserData
    var userManager: UserManager
    @State var errorOccurred = false
    @State var errorDesc = ""
    var body: some View{
        Form{
            Section("Log in"){
                TextField("Username", text: $user.username)
                SecureField("Password",text: $user.password)
            }
            Section{
                Button("Log in"){
                    Task {
                        do {
                            try await userManager.login(user)
                            userData.isLoggedIn = true
                            userData.done = true
                            userData.name = user.username
                        } catch {
                            errorDesc = error.localizedDescription
                            errorOccurred = true
                        }
                    }
                }
                Button("Cancel",role: .destructive){
                    dismiss()
                }
            }
            .alert("An error occurred", isPresented: $errorOccurred){
                
            }message: {
                Text(errorDesc)
            }
        }
        
    }
}

