import SwiftUI

struct LocalSetView: View{
    @State var starred = false
    @Binding var set: CardSet
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
        }
    }
}
