import SwiftUI

struct EditSetView: View {
    @Binding var set: CardSet
    
    var body: some View {
        Form {
            // Edit the title of the set
            TextField("Title", text: $set.name)
            
            // Create a dynamic table based on the cards and their sides
            ForEach(0..<set.cards.count, id: \.self) { cardIndex in
                Section(header: Text("Card \(cardIndex + 1)")) {
                    ForEach(set.cards[cardIndex].sides.keys.sorted(), id: \.self) { key in
                        HStack {
                            // Display the key (side label)
                            Text(key)
                            
                            // TextField for the value of that key (side content)
                            TextField("Enter value", text: Binding(
                                get: {
                                    set.cards[cardIndex].sides[key] ?? ""
                                },
                                set: { newValue in
                                    set.cards[cardIndex].sides[key] = newValue
                                }
                            ))
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
#Preview{
    EditSetView(set: .constant(CardSet(name: "", cards: [Card(sides: ["aa":"bb","cc":"dd"]),Card(sides: ["aa":"aa","cc":"cc"])], creator: "")))
}
