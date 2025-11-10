import SwiftUI

struct LocalSetView: View{
    @State private var starred = false
    @Binding var set: CardSet
    @State private var showSheet = false
    @EnvironmentObject var userData: UserData
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @EnvironmentObject var setsManager: SetsManager
    var body: some View{
        NavigationStack{
            Form{
                Section("Info"){
                    Text("Made by "+set.formattedCreator)
                    if let safeTags = set.tags, !safeTags.isEmpty{
                        ScrollView(.horizontal){
                            HStack{
                                ForEach(Array(safeTags), id: \.self){ tag in
                                    Text(tag)
                                        .padding(5)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(accent))
                                        .foregroundStyle(.black)
                                }
                            }
                        }
                    }else{
                        Text("No tags")
                            .foregroundStyle(.secondary)
                    }
                }
                .listRowBackground(back)
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
                .listRowBackground(back)
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
                        ShareLink(item: URL(string: "https://multicards.phyotp.dev/#/set/"+set.id.uuidString)!){
                            Image(systemName: "square.and.arrow.up")
                        }
                    }
                }
            }
            .navigationTitle(set.name)
            .unifiedBackground()
        }
        .sheet(isPresented: $showSheet){
            EditSetView(set: $set)
                .environmentObject(localSetsManager)
        }
    }
}
