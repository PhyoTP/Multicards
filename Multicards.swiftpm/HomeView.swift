import SwiftUI

struct HomeView: View{
    @StateObject var setsManager = SetsManager()
    @EnvironmentObject var localSetsManager: LocalSetsManager
    var userData: UserData
    @State var localSetID = UUID()
    var body: some View{
        NavigationStack{
            
                if let sets = setsManager.sets{
                    List(sets) { set in
                        NavigationLink(destination: {
                            if set.creator == userData.name {
                                if let localSetIndex = localSetsManager.localSets.firstIndex(where: { $0.id == set.id }) {
                                    LocalSetView(set: $localSetsManager.localSets[localSetIndex])
                                } else {
                                    Text("Set not found locally")
                                        .onAppear(){
                                            localSetsManager.localSets.append(set)
                                            localSetsManager.sync()
                                        }
                                }
                            } else {
                                SetView(set: set)
                                    .environmentObject(localSetsManager)
                            }
                        }) {
                            Text(set.name)
                        }
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
