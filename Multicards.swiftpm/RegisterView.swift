import SwiftUI

struct RegisterView: View{
    @Environment(\.dismiss) var dismiss
    var userData: UserData
    @EnvironmentObject var userManager: UserManager
    @State var errorOccurred = false
    @State var errorDesc = ""
    var body: some View{
        Form{
            Section("Register"){
                TextField("Username", text: $userManager.user.username)
                SecureField("Password",text: $userManager.user.password)
            }
            Section{
                Button("Register"){
                    do{
                        try userManager.register()
                        userData.isLoggedIn = true
                        userData.done = true
                        userData.name = userManager.user.username
                    } catch {
                        errorDesc = error.localizedDescription
                        errorOccurred = true
                        
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
