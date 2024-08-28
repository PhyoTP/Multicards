import SwiftUI

struct LibraryView: View{
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @State private var showSheet = false
    var userData: UserData
    var body: some View{
        NavigationStack{
            List($localSetsManager.localSets, editActions: .all){ $set in
                Text(set.name)
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
                userManager.relogin()
                localSetsManager.sync()
                
            }
        }
        .sheet(isPresented:$showSheet){
            CreateSetView(userData: userData, localSetsManager: localSetsManager)
        }
    }
}
