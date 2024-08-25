import SwiftUI

import SwiftUI

struct CreateSetView: View {
    @State var set: CardSet = CardSet(name: "", cards: [Card(sides: ["":""])], creator: "", isPublic: false)
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var showSheet = false
    var userData: UserData
    var body: some View {
        Form {
            Section{
                Button("Import", systemImage: "square.and.arrow.down"){
                    showSheet = true
                }
            }
            // Title section
            TextField("Title", text: $set.name)
            
            Section("Table") {
                ScrollView(.horizontal) {
                    VStack(alignment: .leading) {
                        // Use a Grid for better column alignment
                        Grid(horizontalSpacing: 10, verticalSpacing: 10) {
                            // Header row with editable keys
                            GridRow {
                                // Enumerate over the keys so we can access both index and value
                                ForEach(Array(set.keys().enumerated()), id: \.element) { (index, key) in
                                    TextField("Dimension", text: Binding(
                                        get: { set.keys()[index] },
                                        set: { newKey in
                                            updateKey(at: index, with: newKey)
                                        }
                                    ))
                                    .padding()
                                    .fontWeight(.bold)
                                    .frame(width: 200, height: 40)
                                    .background(colorScheme == .dark ? Color.black : Color.gray)
                                    .cornerRadius(10)
                                }
                                
                                // "+" Button to add a new key
                                Button("Add dimension",systemImage: "plus") {
                                    addNewKey()
                                } 
                                .padding()
                            }
                            
                            // Rows for cards' values
                            ForEach($set.cards) { $card in
                                GridRow {
                                    ForEach(set.keys(), id: \.self) { key in
                                        TextField("Enter value", text: Binding(
                                            get: { card.sides[key] ?? "" },
                                            set: { newValue in card.sides[key] = newValue }
                                        ))
                                        .padding()
                                        .frame(width: 200, height: 40)
                                        .background(colorScheme == .dark ? Color.black : Color.gray)
                                        .cornerRadius(10)
                                    }
                                }
                            }
                        }
                        
                        // "+" Button to add a new card
                        Button("Add card",systemImage: "plus") {
                            addNewCard()
                        } 
                        .padding()
                    }
                }
            }
            Section{
                Button("Create"){
                    
                }
                Button("Cancel", role: .destructive){
                    dismiss()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showSheet){
            ImportView(userData: userData, result:$set)
        }
    }
    
    // Function to add a new key to all cards
    func addNewKey() {
        let newKey = "New Dimension"
        
        // Add the new key to every card's sides
        for index in set.cards.indices {
            set.cards[index].sides[newKey] = ""
        }
    }
    
    // Function to add a new card
    func addNewCard() {
        let newCard = Card(sides: [:])
        set.cards.append(newCard)
    }
    
    // Function to update a key in all cards
    func updateKey(at index: Int, with newKey: String) {
        let oldKey = set.keys()[index]
        
        // Update the key in all cards
        for cardIndex in set.cards.indices {
            if let value = set.cards[cardIndex].sides.removeValue(forKey: oldKey) {
                set.cards[cardIndex].sides[newKey] = value
            }
        }
    }
}

