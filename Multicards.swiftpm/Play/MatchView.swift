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
    var body: some View{
        Grid{
            GridRow{
                ForEach(chosenValues(question, num: 3).values, id: \.self){value in
                    VStack{
                        Text(question.name)
                        Text(value)
                    }
                    .frame(width: 100, height: 200)
                    .background(Color(uiColor: .systemGray3))
                    .mask{
                        RoundedRectangle(cornerRadius: 20)
                    }
                }
            }
            GridRow{
                ForEach(chosenValues(answer, num: 3).values, id: \.self){value in
                    VStack{
                        Text(answer.name)
                        Text(value)
                    }
                    .frame(width: 100, height: 200)
                    .background(Color(uiColor: .systemGray3))
                    .mask{
                        RoundedRectangle(cornerRadius: 20)
                    }
                }
            }
        }
        .onAppear(){
            cards = prepareCards(questions: questions, answers: answers)
        }
        .multilineTextAlignment(.center)
    }
}
