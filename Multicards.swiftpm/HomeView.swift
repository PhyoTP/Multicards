import SwiftUI

struct HomeView: View{
    @StateObject var setsManager = SetsManager()
    @EnvironmentObject var localSetsManager: LocalSetsManager
    var userData: UserData
    @State var localSetID = UUID()
    @State var input = ""
    var filteredSets: [CardSet]{
        if let sets = setsManager.sets{
            if input.isEmpty{
                return sets
            }else{
                return sets.filter{$0.name.lowercased().contains(input.lowercased())}
            }
        }else{
            return []
        }
    }
    var body: some View{
        NavigationStack{
            
                if (setsManager.sets != nil){
                    List(filteredSets) { set in
                        NavigationLink(destination: {
                            if set.creator == userData.name {
                                if let localSetIndex = localSetsManager.localSets.firstIndex(where: { $0.id == set.id }) {
                                    LocalSetView(set: $localSetsManager.localSets[localSetIndex], userData: userData)
                                        .environmentObject(localSetsManager)
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
                    .searchable(text: $input, placement: .navigationBarDrawer, prompt: "Search")
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
