import SwiftUI

struct SetView: View {
    @State var starred = false
    var set: CardSet
    @EnvironmentObject var localSetsManager: LocalSetsManager
    
    var body: some View {
        NavigationStack {
            Form {
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
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        PlayView(set: set)
                    } label: {
                        Image(systemName: "play")
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if starred {
                        Button {
                            starred = false
                            if let index = localSetsManager.localSets.firstIndex(where: { $0.id == set.id }) {
                                localSetsManager.localSets.remove(at: index)
                                localSetsManager.updateSets()
                            }
                        } label: {
                            Image(systemName: "star.fill")
                        }
                    } else {
                        Button {
                            starred = true
                            localSetsManager.localSets.append(set)
                            localSetsManager.updateSets()
                        } label: {
                            Image(systemName: "star")
                        }
                    }
                }
            }
            .navigationTitle(set.name)
            .onAppear {
                if localSetsManager.localSets.contains(where: { $0.id == set.id }) {
                    starred = true
                }
            }
        }
    }
}