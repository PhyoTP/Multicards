import SwiftUI

struct StartView: View{
    var userData: UserData
    var body: some View{
        VStack{
            Text("Welcome to Multicards")
                .font(.system(size: 34, weight: .bold, design: .rounded))
            Button("Log in to PhyoID"){
                
            }
            .frame(width: 200)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
            Button("Sign up"){
                
            }
            .frame(width: 200)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
            Button("Join as Guest"){
                userData.done = true
            }
            .frame(width: 200)
            .padding()
            .background(.blue)
            .foregroundStyle(.white)
            .cornerRadius(10)
        }
    }
}
#Preview{
    StartView(userData: UserData())
}
