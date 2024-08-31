import SwiftUI

struct MatchView: View{
    @State var cards: [Card] = []
    var questions: [Column]
    var answers: [Column]
    var question: Column {
        combineColumns(questions)
    }
    var answer: Column {
        combineColumns(answers)
    }
    func chosenValues(_ column: Column, num: Int)-> Column{
        var tempColumn = column
        tempColumn.values.shuffle()
        tempColumn.values = Array(tempColumn.values.prefix(num))
        return tempColumn
    }
    var chosenCards: [Card]{
        return Array(cards.shuffled().prefix(8))
    }
    var cardArray: [(String, String, UUID)]{
        var tempArray: [(String, String, UUID)] = []
        for i in chosenCards{
            tempArray.append((question.name, i.sides[question.name] ?? "", UUID()))
        }
        for i in chosenCards{
            tempArray.append((answer.name, i.sides[answer.name] ?? "", UUID()))
        }
        return tempArray.shuffled()
    }
    let columns = [GridItem(.adaptive(minimum: 80))]
    @State var selectedQuestion: (String, String)?
    @State var selectedAnswer: (String, String)?
    @State var properties: [(Double, Bool, UUID)] = []
    var body: some View{
        LazyVGrid(columns: columns){
            ForEach(cardArray, id: \.2){card in
                Button{
                    
                }label: {
                    
                    VStack{
                        Text(card.0)
                        Text(card.1)
                    }
                }
                .frame(width: 90, height: 135)
                .background(Color(uiColor: (properties.first(where: {$0.2 == card.2})?.1) ?? false ? .systemGray4 : .systemGray6))
                .mask{
                    RoundedRectangle(cornerRadius: 10)
                }
                .opacity((properties.first(where: {$0.2 == card.2})?.0) ?? 1)
            }
        }
        .onAppear(){
            cards = prepareCards(questions: questions, answers: answers)
            for i in cardArray{
                properties.append((1, false, i.2))
            }
        }
        .multilineTextAlignment(.center)
    }
}
