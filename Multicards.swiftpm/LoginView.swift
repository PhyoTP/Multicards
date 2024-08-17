import SwiftUI

struct LoginView: View{
    @State private var name = ""
    @State private var password = ""
    @Environment(\.dismiss) var dismiss
    var body: some View{
        Form{
            Section("Log in"){
                TextField("Username", text: $name)
                TextField("Password",text: $password)
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
#Preview{
    LoginView()
}
