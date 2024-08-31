import SwiftUI

struct MatchView: View {
    var cards: [Card]
    
    
    // Select up to 8 random cards if there are more than 8 cards
    var chosenCards: [Card] {
        if cards.count <= 8 {
            return cards.shuffled()
        } else {
            return Array(cards.shuffled().prefix(8))
        }
    }
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))]){
            ForEach(chosenCards){card in
                Text("a")
            }
        }
        
    }
}
