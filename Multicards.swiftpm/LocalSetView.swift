import SwiftUI

struct LocalSetView: View{
    @State var starred = false
    @Binding var set: CardSet
    var body: some View{
        NavigationStack{
            Form{
                Section("info"){
                    Text("Made by "+set.creator)
                }
                Section("Table"){
                    ScrollView(.horizontal){
                        Grid {
                            // Column Headers
                            GridRow {
                                ForEach(set.keys(), id: \.self) { key in
                                    if key != set.keys()[0]{
                                        HStack{Divider()}
                                    }
                                    Text(key)
                                        .bold()
                                }
                            }
                            
                            
                            // Card rows
                            ForEach(set.cards) { card in
                                Divider()
                                GridRow {
                                    ForEach(set.keys(), id: \.self) { key in
                                        if key != set.keys()[0]{
                                            HStack{Divider()}
                                        }
                                        Text(card.sides[key] ?? "")
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
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
                        Image(systemName: "ellipsis.circle")
                    }
                }
                
            }
            .navigationTitle(set.name)
        }
    }
}
