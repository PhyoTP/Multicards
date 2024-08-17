import SwiftUI

struct LoginView: View{
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    var userData: UserData
    var body: some View{
        Form{
            Section("Log in"){
                TextField("Username", text: $user.username)
                TextField("Password",text: $user.password)
            }
            Section{
                Button("Log in"){
                    
                }
                Button("Cancel",role: .destructive){
                    dismiss()
                }
            }
        }
        
    }
}

