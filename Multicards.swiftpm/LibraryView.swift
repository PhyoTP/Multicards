import SwiftUI

struct LibraryView: View{
    @EnvironmentObject var userManager: UserManager
    @StateObject var localSetsManager = LocalSetsManager()
    @State private var showNewSheet = false
    @State private var showImportSheet = false
    var userData: UserData
    var body: some View{
        NavigationStack{
            List($localSetsManager.localSets, id: \.self, editActions: .all){ $set in
                Text(set.name)
            }
            .navigationTitle("Library")
            .toolbar(){
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        showNewSheet = true
                    }label:{
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading){
                    Button{
                        showImportSheet = true
                    }label:{
                        Image(systemName: "square.and.arrow.down")
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    EditButton()
                }
            }
            .refreshable {
                Task {
                    try await userManager.login()
                    try await localSetsManager.sync()
                }
            }
            .onChange(of: localSetsManager.localSets){
                Task {
                    try await userManager.login()
                    try await localSetsManager.sync()
                }
            }
        }
        .sheet(isPresented:$showNewSheet){
            
        }
        .sheet(isPresented: $showImportSheet){
            ImportView(userData: userData, localSetsManager: localSetsManager)
        }
    }
}
