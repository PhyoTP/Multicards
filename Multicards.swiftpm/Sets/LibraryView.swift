import SwiftUI

struct LibraryView: View{
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @EnvironmentObject var setsManager: SetsManager
    @State private var showSheet = false
    @EnvironmentObject var userData: UserData
    var covers: [SetCover]{
        if input.isEmpty{
            return localSetsManager.localSets.map{SetCover(id: $0.id, name: $0.name, creator: $0.creator, cardCount: $0.cards.count)}
        }else{
            return localSetsManager.localSets.map{SetCover(id: $0.id, name: $0.name, creator: $0.creator, cardCount: $0.cards.count)}.filter{$0.name.lowercased().contains(input.lowercased())}
        }
    }
    @State private var input = ""
    var body: some View{
        NavigationStack{
            Section(""){
                List{
                    ForEach(covers){ set in
                        RedirectSetView(set: set)
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
                .searchable(text: $input)
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
        }
        .sheet(isPresented:$showSheet){
            CreateSetView()
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
