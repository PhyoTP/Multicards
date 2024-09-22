import SwiftUI

struct LibraryView: View{
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @EnvironmentObject var setsManager: SetsManager
    @State private var showSheet = false
    var userData: UserData
    var body: some View{
        NavigationStack{
            List{
                ForEach(localSetsManager.localSets){ localSet in
                    NavigationLink(destination: {
                        if let localSetIndex = localSetsManager.localSets.firstIndex(where: { $0.id == localSet.id }) {
                            if localSet.creator == userData.name{
                                LocalSetView(set: $localSetsManager.localSets[localSetIndex], userData: userData)
                                    .environmentObject(localSetsManager)
                            }else{
                                SetView(setID: localSetsManager.localSets[localSetIndex].id)
                                    .environmentObject(localSetsManager)
                                    .environmentObject(setsManager)
                            }
                        } else {
                            Text("Set not found locally")
                        }
                    }) {
                        Text(localSet.name)
                    }
                }
                .onDelete(perform: { indexSet in
                    for i in indexSet{
                        if localSetsManager.localSets[i].isPublic{
                            localSetsManager.deleteSet(localSetsManager.localSets[i])
                        }
                    }
                    localSetsManager.localSets.remove(atOffsets: indexSet)
                    localSetsManager.updateSets()
                    
                })
            }
            .navigationTitle("Library")
            .toolbar(){
                ToolbarItem(placement: .topBarTrailing){
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        showSheet = true
                    }label:{
                        Image(systemName: "plus")
                    }
                }
            }
            .refreshable {
                load()
            }
            .onAppear(){
                load()
            }
        }
        .sheet(isPresented:$showSheet){
            CreateSetView(userData: userData)
                .environmentObject(localSetsManager)
                .environmentObject(setsManager)
        }
    }
    func load(){
        for i in localSetsManager.localSets.indices{
            if localSetsManager.localSets[i].creator == "You"{
                localSetsManager.localSets[i].creator = userData.name
            }
        }
        userManager.relogin()
        localSetsManager.sync()
    }
}
