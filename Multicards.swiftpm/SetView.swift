import SwiftUI

struct SetView: View{
    @State var starred = false
    var set: CardSet
    @State var columns: [Column] = []
    @EnvironmentObject var localSetsManager: LocalSetsManager
    var body: some View{
        NavigationStack{
            Form{
                
            }
            .toolbar(){
                ToolbarItem(placement: .topBarTrailing){
                    Button{
                        
                    }label: {
                        Image(systemName: "play")
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    if starred{
                        Button{
                            starred = false
                            localSetsManager.sync()
                            if let index = localSetsManager.localSets.firstIndex(where: {$0.id == set.id}){
                                localSetsManager.localSets.remove(at: index)
                            }
                            localSetsManager.updateSets()
                        }label: {
                            Image(systemName: "star.fill")
                        }
                    }else{
                        Button{
                            starred = true
                            localSetsManager.localSets.append(set)
                            localSetsManager.sync()
                        }label: {
                            Image(systemName: "star")
                        }
                    }
                    
                }
            }
            .navigationTitle(set.name)
            .onAppear(){
                if localSetsManager.localSets.contains(where: {$0.id == set.id}){
                    starred = true
                }
            }
        }
    }
}
