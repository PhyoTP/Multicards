import SwiftUI

struct HomeView: View{
    @EnvironmentObject var setsManager: SetsManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    var userData: UserData
    @State private var localSetID = UUID()
    @State private var input = ""
    var filteredSets: [SetCover]{
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
                                        .environmentObject(setsManager)
                                } else {
                                    Text("Set not found locally")
                                        .onAppear(){
                                            Task{
                                                try await localSetsManager.localSets.append(setsManager.getSet(set.id))
                                            }
                                            localSetsManager.sync()
                                        }
                                }
                            } else {
                                SetView(setID: set.id)
                                    .environmentObject(localSetsManager)
                                    .environmentObject(setsManager)
                            }
                        }) {
                            VStack{
                                Text(set.name)
                                Text("By "+set.creator)
                                    .font(.caption)
                            }
                            
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
