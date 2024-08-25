import SwiftUI

struct CreateSetView: View {
    @State var set: CardSet = CardSet(name: "", cards: [Card(sides: ["":""])], creator: "", isPublic: false)
    @State var keys: [String] = [""]
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
                                ForEach(Array(keys.enumerated()), id: \.element) { (index, key) in
                                    TextField("Dimension", text: $keys[index])
                                        .padding()
                                        .fontWeight(.bold)
                                        .frame(width: 200, height: 40)
                                        .background(colorScheme == .dark ? Color.black : Color.gray)
                                        .cornerRadius(10)
                                        .onSubmit{
                                            updateKey(at: index, with: keys[index])
                                        }
                                }
                                
                                // "+" Button to add a new key
                                Button("Add dimension", systemImage: "plus") {
                                    addNewKey()
                                }
                                .padding()
                            }
                            
                            // Rows for cards' values
                            ForEach($set.cards) { $card in
                                GridRow {
                                    ForEach(keys, id: \.self) { key in
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
                        Button("Add card", systemImage: "plus") {
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
            ImportView(userData: userData, result: $set)
        }
        .onAppear {
            keys = set.keys() // Initialize the keys
        }
    }
    
    func addNewKey() {
        let newKey = "New Dimension"
        keys.append(newKey)
        
        // Add the new key to every card's sides
        for index in set.cards.indices {
            set.cards[index].sides[newKey] = ""
        }
    }
    
    func addNewCard() {
        let newCard = Card(sides: [:])
        set.cards.append(newCard)
    }
    
    func updateKey(at index: Int, with newKey: String) {
        let oldKey = keys[index]
        
        // Update the key in all cards
        for cardIndex in set.cards.indices {
            if let value = set.cards[cardIndex].sides.removeValue(forKey: oldKey) {
                set.cards[cardIndex].sides[newKey] = value
            }
        }
    }
}

