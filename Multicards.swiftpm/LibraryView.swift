import SwiftUI

struct LibraryView: View{
    @StateObject var localSetsManager = LocalSetsManager()
    @State private var showNewSheet = false
    @State private var showImportSheet = false
    var userData: UserData
    var body: some View{
        NavigationStack{
            List(localSetsManager.localSets, id: \.self){ set in
                
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
            }
        }
        .sheet(isPresented:$showNewSheet){
            
        }
        .sheet(isPresented: $showImportSheet){
            ImportView(userData: userData)
        }
    }
}
