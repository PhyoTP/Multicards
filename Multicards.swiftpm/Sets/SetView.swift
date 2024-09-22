import SwiftUI

struct SetView: View {
    @State private var starred = false
    var setID: UUID
    @State private var convertedSet: CardSet?
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @EnvironmentObject var setsManager: SetsManager
    var body: some View {
        if let set = convertedSet{
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
                    if set.isPublic{
                        ToolbarItem(placement: .topBarTrailing){
                            ShareLink(item: URL(string: "https://multicards.phyotp.dev/#/set/"+set.id.uuidString)!){
                                Image(systemName: "square.and.arrow.up")
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
        }else{
            ProgressView()
                .onAppear(){
                    Task{
                        do {
                            convertedSet = try await setsManager.getSet(setID)
                        }catch{
                            convertedSet = localSetsManager.localSets.first(where: {$0.id == setID})
                        }
                        
                    }
                }
        }
    }
}
