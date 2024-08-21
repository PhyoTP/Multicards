import SwiftUI

struct HomeView: View{
    @StateObject var setsManager = SetsManager()
    var userData: UserData
    var body: some View{
        NavigationStack{
            
                if let sets = setsManager.sets{
                    List(sets, id: \.self){ set in
                        Text(set.name)
                    }
                    .navigationTitle(userData.isLoggedIn ? "Hello, " + userData.name : "Multicards")
                    .refreshable{
                        setsManager.getSets()
                        print(userData.isLoggedIn)
                    }
                }else{
                    ProgressView()
                        .progressViewStyle(.circular)
                        .onAppear(){
                            setsManager.getSets()
                            print(userData.isLoggedIn)
                        }
                }
            
        }
        
    }
}
