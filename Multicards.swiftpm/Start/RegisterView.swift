import SwiftUI

struct RegisterView: View{
    @Environment(\.dismiss) var dismiss
    var userData: UserData
    @EnvironmentObject var userManager: UserManager
    @State private var errorOccurred = false
    @State private var errorDesc = ""
    var body: some View{
        Form{
            Section("Register"){
                TextField("Username", text: $userManager.user.username)
                SecureField("Password",text: $userManager.user.password)
            }
            Section{
                Button("Register"){
                    Task{
                        do{
                            try await userManager.register()
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
