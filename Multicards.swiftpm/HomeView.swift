import SwiftUI

struct HomeView: View{
    @StateObject var setsManager = SetsManager()
    var userData: UserData
    var body: some View{
        NavigationStack{
            
                if let sets = setsManager.sets{
                    List(sets){ set in
                        Text(set.name)
                    }
                    .navigationTitle(userData.isLoggedIn ? "Hello, " + userData.name : "Multicards")
                    .refreshable{
                        setsManager.getSets()
                        
                    }
                }else{
                    ProgressView()
                        .progressViewStyle(.circular)
                        .onAppear(){
                            setsManager.getSets()
                            
                        }
                }
            
        }
        
    }
}
