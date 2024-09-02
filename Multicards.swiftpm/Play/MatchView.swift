import SwiftUI

struct MatchView: View {
    @State var cards: [Card] = []
    var questions: [Column]
    var answers: [Column]
    
    @State var cardGrid: [[Side]] = []
    @State var selected: Side?
    var body: some View {
        Grid {
            ForEach($cardGrid, id: \.self) { $row in
                GridRow {
                    ForEach($row) { $side in
                        Button{
                            if let select = selected{
                                if select.id == side.id{
                                    side.color = .systemGray4
                                    print("unselect")
                                }else if side.cardID == select.cardID{
                                    side.color = .green
                                    withAnimation(){
                                        side.opacity = 0
                                    }
                                    for i in cardGrid.indices{
                                        if let index = cardGrid[i].firstIndex(where: {$0.cardID == side.cardID}){
                                            print("found")
                                            cardGrid[i][index].color = .green
                                            withAnimation(){
                                                cardGrid[i][index].opacity = 0
                                            }
                                        }
                                        
                                    }
                                    print("correct")
                                }else{
                                    side.color = .red
                                    withAnimation(){
                                        side.color = .systemGray4
                                    }
                                    for i in cardGrid.indices{
                                        if let index = cardGrid[i].firstIndex(where: {$0.cardID == side.cardID}){
                                            print("found")
                                            cardGrid[i][index].color = .red
                                            withAnimation(){
                                                cardGrid[i][index].color = .systemGray4
                                            }
                                            
                                        }
                                    }
                                    print("wrong")
                                }
                                selected = nil
                            }else{
                                selected = side
                                side.color = .systemGray
                                print("new")
                            }
                        }label:{
                            VStack{
                                Text(side.title)
                                    .fontWeight(.medium)
                                Text(side.value)
                            }
                        }
                        .frame(minWidth: 75, idealWidth: 100, maxWidth: 150, minHeight: 150)
                        .background(Color(side.color))
                        .mask{
                            RoundedRectangle(cornerRadius: 10)
                        }
                        .opacity(Double(side.opacity))
                    }
                }
            }
        }
        .onAppear{
            cards = Array(prepareCards(questions: questions, answers: answers).shuffled().prefix(8))
                var allSides: [Side] = []
                
                for card in cards {
                    allSides.append(contentsOf: card.newSides)
                }
                
                allSides.shuffle()
            
            
            // Dynamically create rows based on the number of sides
            let columnsPerRow = (cards.count == 6) ? 3 : (cards.count == 8) ? 4 : 2
            let numRows = (allSides.count + columnsPerRow - 1) / columnsPerRow
            
            for rowIndex in 0..<numRows {
                let start = rowIndex * columnsPerRow
                let end = min(start + columnsPerRow, allSides.count)
                if start < end {
                    let row = Array(allSides[start..<end])
                    cardGrid.append(row)
                }
            }
        }
    }
}
