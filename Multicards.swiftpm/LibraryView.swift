import SwiftUI

struct LibraryView: View{
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @State private var showSheet = false
    var userData: UserData
    var body: some View{
        NavigationStack{
            List{
                ForEach($localSetsManager.localSets){ $set in
                    NavigationLink(destination: {
                        if set.creator == userData.name {
                            if let localSetIndex = localSetsManager.localSets.firstIndex(where: { $0.id == set.id }) {
                                LocalSetView(set: $localSetsManager.localSets[localSetIndex])
                            } else {
                                Text("Set not found locally")
                            }
                        } else {
                            SetView(set: set)
                                .environmentObject(localSetsManager)
                        }
                    }) {
                        Text(set.name)
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
            CreateSetView(userData: userData, localSetsManager: localSetsManager)
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
