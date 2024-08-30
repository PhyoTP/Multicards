import SwiftUI

struct StartView: View {
    var userData: UserData
    @State var login = false
    @State var register = false
    @EnvironmentObject var userManager: UserManager
    var body: some View {
        VStack {
            Text("Welcome to Multicards")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Button("Log in to PhyoID") {
                login = true
            }
            .frame(width: 200)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
            Button("Register for a PhyoID") {
                register = true
            }
            .frame(width: 200)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
            Button("Join as a Guest") {
                userData.done = true
            }
            .frame(width: 200)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
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
