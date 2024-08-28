import SwiftUI

struct SetView: View{
    @State var starred = false
    var set: CardSet
    @State var columns: [Column] = []
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
                    Button{
                        
                    }label: {
                        if starred{
                            Image(systemName: "star.fill")
                        }else{
                            Image(systemName: "star")
                        }
                    }
                }
            }
            .navigationTitle(set.name)
        }
    }
}
