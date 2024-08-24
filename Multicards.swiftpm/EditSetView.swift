import SwiftUI

struct EditSetView: View {
    @Binding var set: CardSet
    
    var body: some View {
        Form {
            TextField("Title", text: $set.name)
            
            Section("Table") {
                ScrollView(.horizontal) {
                    VStack(alignment: .leading) {
                        // Use a Grid for better column alignment
                        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                            GridRow {
                                ForEach(set.keys(), id: \.self) { key in
                                    Text(key)
                                        .fontWeight(.bold)
                                        .frame(width: 200)
                                }
                                // "+" Button to add a new key
                                Button{
                                    // Add a new key
                                    
                                }label: {
                                    Image(systemName: "plus")
                                        .padding()
                                }
                            }
                            
                            ForEach($set.cards) { $card in
                                GridRow {
                                    ForEach(set.keys(), id: \.self) { key in
                                        TextField("Enter value", text: Binding(
                                            get: { card.sides[key] ?? "" },
                                            set: { newValue in card.sides[key] = newValue }
                                        ))
                                        .padding()
                                        .frame(width: 200)
                                    }
                                }
                            }
                        }
                        
                        // "+" Button to add a new card
                        Button{
                            let newCard = Card(sides: [:])
                            set.cards.append(newCard)
                        }label: {
                            Image(systemName: "plus")
                                .padding()
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EditSetView(set: .constant(CardSet(
        name: "Sample Set",
        cards: [Card(sides: ["aa": "bb", "cc": "dd"]), Card(sides: ["aa": "aa"]),Card(sides: ["cc":"cc","dd":"ee"])],
        creator: "John Doe"
    )))
}
