import SwiftUI

struct FlashcardsView: View {
    var cards: [Card]
    
    var body: some View {
        ZStack {
            ForEach(cards) { card in
                ForEach(Array(card.sides), id: \.key) { (key, value) in
                    VStack {
                        Text(key)
                        Text(value)
                    }
                    .frame(width: 200, height: 400)
                    .background(Color(uiColor: .systemGray4))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                }
            }
        }
    }
}
