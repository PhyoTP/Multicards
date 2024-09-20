import SwiftUI

struct LocalSetView: View{
    @State var starred = false
    @Binding var set: CardSet
    @State var showSheet = false
    var userData: UserData
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @StateObject var setsManager = SetsManager()
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
                            
                            Rectangle()
                                .fill(Color(.systemGray3))
                                .frame(height: 3)
                            // Card rows
                            ForEach(set.cards) { card in
                                if card.id != set.cards[0].id{
                                    Divider()
                                }
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
                    NavigationLink{
                        PlayView(set: set)
                    }label: {
                        Image(systemName: "play")
                    }
                }
                ToolbarItem(placement: .topBarTrailing){
                    Menu{
                        Button("Edit set"){
                            showSheet = true
                        }
                        if set.isPublic{
                            Button("Set to private"){
                                set.isPublic = false
                                localSetsManager.sync()
                                localSetsManager.deleteSet(set)
                                setsManager.getSets()
                            }
                        }else{
                            Button("Set to public"){
                                set.isPublic = true
                                localSetsManager.sync()
                                setsManager.postSet(set)
                                setsManager.getSets()
                            }
                        }
                    }label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                if set.isPublic{
                    ToolbarItem(placement: .topBarTrailing){
                        Link(destination: URL(string: "https://multicards.phyotp.dev/#/set/"+set.id.uuidString)!){
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
            .navigationTitle(set.name)
        }
        .sheet(isPresented: $showSheet){
            EditSetView(set: $set, userData: userData, localSetsManager: localSetsManager)
        }
    }
}
