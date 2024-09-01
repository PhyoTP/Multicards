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
    @State var cardArray: [(Int, String, String, Double, UIColor, Bool, UUID)] = []
    
    
    let columns = [GridItem(.adaptive(minimum: 80))]
    @State var selectedQuestion: (String, String, Int)?
    @State var selectedAnswer: (String, String, Int)?
    var body: some View{
        LazyVGrid(columns: columns){
            ForEach($cardArray, id: \.6){$card in
                Button{
                    if card.4 == .systemGray4{
                        card.4 = .systemGray
                        if card.5{
                            if let select = selectedQuestion{
                                cardArray[cardArray.firstIndex(where: {
                                    (select.0, select.1) == ($0.1, $0.2)
                                })!].4 = .systemGray4
                                selectedQuestion = (card.1, card.2, card.0)
                            }else{
                                selectedQuestion = (card.1, card.2, card.0)
                            }
                            
                        }else{
                            if let select = selectedAnswer{
                                cardArray[cardArray.firstIndex(where: {
                                    (select.0, select.1) == ($0.1, $0.2)
                                })!].4 = .systemGray4
                                selectedAnswer = (card.1, card.2, card.0)
                            }else{
                                selectedAnswer = (card.1, card.2, card.0)
                            }
                        }
                        if let selectA = selectedAnswer{
                            if let selectQ = selectedQuestion{
                                if selectA.2 == selectQ.2{
                                    cardArray[cardArray.firstIndex(where: {
                                        (selectA.0, selectA.1) == ($0.1, $0.2)
                                    })!].4 = .systemGreen
                                    cardArray[cardArray.firstIndex(where: {
                                        (selectQ.0, selectQ.1) == ($0.1, $0.2)
                                    })!].4 = .systemGreen
                                    
                                    withAnimation(){
                                        cardArray[cardArray.firstIndex(where: {
                                            (selectA.0, selectA.1) == ($0.1, $0.2)
                                        })!].3 = 0
                                        cardArray[cardArray.firstIndex(where: {
                                            (selectQ.0, selectQ.1) == ($0.1, $0.2)
                                        })!].3 = 0
                                        selectedQuestion = nil
                                        selectedAnswer = nil
                                    }
                                }else{
                                    cardArray[cardArray.firstIndex(where: {
                                        (selectA.0, selectA.1) == ($0.1, $0.2)
                                    })!].4 = .systemRed
                                    cardArray[cardArray.firstIndex(where: {
                                        (selectQ.0, selectQ.1) == ($0.1, $0.2)
                                    })!].4 = .systemRed
                                    withAnimation(){
                                        cardArray[cardArray.firstIndex(where: {
                                            (selectA.0, selectA.1) == ($0.1, $0.2)
                                        })!].4 = .systemGray4
                                        cardArray[cardArray.firstIndex(where: {
                                            (selectQ.0, selectQ.1) == ($0.1, $0.2)
                                        })!].4 = .systemGray4
                                        selectedQuestion = nil
                                        selectedAnswer = nil
                                    }
                                }
                            }
                        }
                    }else if card.4 == .systemGray{
                        card.4 = .systemGray4
                        if card.5{
                            selectedQuestion = nil
                        }else{
                            selectedAnswer = nil
                        }
                    }
                    
                }label: {
                    
                    VStack{
                        Text(card.1)
                        Text(card.2)
                    }
                }
                .frame(width: 90, height: 135)
                .background(Color(uiColor: card.4))
                .mask{
                    RoundedRectangle(cornerRadius: 10)
                }
                .opacity(card.3)
                .foregroundStyle(.white)
            }
        }
        .onAppear(){
            cards = prepareCards(questions: questions, answers: answers)
            print(chosenCards)
            for i in chosenCards.indices{
                cardArray.append((i, question.name, chosenCards[i].sides[question.name] ?? "", 1, .systemGray4, true, UUID()))
            }
            for i in chosenCards.indices{
                cardArray.append((i, answer.name, chosenCards[i].sides[answer.name] ?? "", 1, .systemGray4, false, UUID()))
            }
            cardArray.shuffle()
            print(cardArray)
        }
        .multilineTextAlignment(.center)
    }
}
