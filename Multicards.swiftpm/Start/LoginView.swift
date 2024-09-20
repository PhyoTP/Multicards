import SwiftUI

struct LoginView: View{
    @Environment(\.dismiss) var dismiss
    var userData: UserData
    @EnvironmentObject var userManager: UserManager
    @State var errorOccurred = false
    @State var errorDesc = ""
    var body: some View{
        Form{
            Section("Log in"){
                TextField("Username", text: $userManager.user.username)
                SecureField("Password",text: $userManager.user.password)
            }
            Section{
                Button("Log in"){
                    Task {
                        do {
                            try await userManager.login()
                            userData.isLoggedIn = true
                            userData.done = true
                            userData.name = userManager.user.username
                            dismiss()
                        } catch {
                            errorDesc = userManager.error
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

