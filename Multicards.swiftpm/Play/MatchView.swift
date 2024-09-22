import SwiftUI

struct MatchView: View {
    @State private var cards: [Card] = []
    var questions: [Column]
    var answers: [Column]
    @State private var cardGrid: [[Side]] = []
    @State private var selected: Side?
    @State private var startTime = Date()
    @State private var elapsedTime: TimeInterval = 0
    @State private var timer: Timer?
    @State private var count = 0
    @State private var best: TimeInterval = 0
    @State private var done = false
    var body: some View {
        if done{
            VStack{
                Text(String(format: "%.1f",elapsedTime))
                Text("Best: "+String(format: "%.1f",best))
                Button("Try again"){
                    resetGame()
                    start()
                }
                .frame(width: 200)
                .padding()
                .background(.blue)
                .foregroundStyle(.white)
                .cornerRadius(10)
            }
        }else{
            VStack{
                Text(String(format: "%.1f",elapsedTime))
                    .fontWeight(.medium)
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
                                            for i in cardGrid.indices{
                                                for j in cardGrid[i].indices{
                                                    if cardGrid[i][j].cardID == select.cardID{
                                                        cardGrid[i][j].color = .systemGreen
                                                        withAnimation{
                                                            cardGrid[i][j].opacity = 0
                                                        }
                                                        
                                                    }
                                                }
                                                
                                            }
                                            count+=1
                                            
                                            if count == cards.count{
                                                timer?.invalidate()
                                                timer = nil
                                                if best == 0 || elapsedTime<best{
                                                    best = elapsedTime
                                                    print("better")
                                                }
                                                done = true
                                            }
                                        }else{
                                            
                                            for i in cardGrid.indices{
                                                if let index = cardGrid[i].firstIndex(where: {$0.id == select.id}){
                                                    side.color = .red
                                                    
                                                    print("found")
                                                    cardGrid[i][index].color = .red
                                                    withAnimation(){
                                                        cardGrid[i][index].color = .systemGray4
                                                        side.color = .systemGray4
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
                                        Divider()
                                        Text(side.value)
                                    }
                                }
                                .frame(minWidth: 75, idealWidth: 100, maxWidth: 150, minHeight: 140)
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
                    start()
                }
            }
        }
    }
    func start() {
        // Initialize the game state
        startTime = Date()
        elapsedTime = 0
        count = 0
        done = false
        
        // Start the timer
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            elapsedTime = Date().timeIntervalSince(startTime)
        }
        
        // Prepare the cards and sides
        cards = Array(prepareCards(questions: questions, answers: answers).shuffled().prefix(8))
        cardGrid = []
        
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
    func resetGame() {
        // Reset the game state
        cardGrid = []
        selected = nil
        startTime = Date()
        elapsedTime = 0
        timer?.invalidate()
        count = 0
        done = false
    }
}
