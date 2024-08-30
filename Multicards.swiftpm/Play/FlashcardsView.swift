import SwiftUI

struct FlashcardsView: View {
    @State var cards: [Card] = []
    var questions: [Column]
    var answers: [Column]
    var question: Column {
        combineColumns(questions)
    }
    var answer: Column {
        combineColumns(answers)
    }
    @State var tapped = false
    @State var rotation = 0.0
    @State var offsets: [CGFloat] = []
    @State var know: [Card] = []
    @State var dontKnow: [Card] = []
    var body: some View {
        VStack{
            HStack{
                Spacer()
                Image(systemName: "arrow.left")
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.system(size: 30))
                Spacer()
                Image(systemName: "multiply.circle.fill")
                    .foregroundStyle(.red)
                    .font(.system(size: 30))
                Image(systemName: "arrow.right")
                Spacer()
            }
            ZStack {
                ForEach(cards) { card in
                    VStack {
                        if tapped{
                            Text(answer.name)
                                .scaleEffect(x: -1, y: 1)
                                .fontWeight(.medium)
                            Divider()
                            Text(card.sides[answer.name] ?? "")
                                .scaleEffect(x: -1, y: 1)
                        }else{
                            Text(question.name)
                                .fontWeight(.medium)
                            Divider()
                            Text(card.sides[question.name] ?? "")
                        }
                    }
                    .frame(width: 200, height: 400)
                    .background(Color(uiColor: .systemGray4))
                    .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
                    .gesture(
                        DragGesture(minimumDistance: 0, coordinateSpace: .local)
                            .onEnded({value in
                                if value.translation.width < 0{
                                    withAnimation(){
                                        know.append(card)
                                    }
                                }
                                if value.translation.width > 0{
                                    withAnimation(){
                                        dontKnow.append(card)
                                    }
                                }
                            })
                    )
                    .highPriorityGesture(
                        TapGesture()
                            .onEnded{
                                withAnimation(){
                                    rotation += 180
                                }
                                tapped.toggle()
                            }
                    )
                    .rotation3DEffect(
                        Angle(degrees: rotation), axis: (x: 0.0, y: 1.0, z: 0.0)
                    )
                    .offset(x: 
                                know.contains(where: {$0.id==card.id}) ? 
                            tapped ?
                            500 :
                                -500 
                            : 
                                dontKnow.contains(where: {$0.id==card.id}) ?
                            tapped ? 
                            -500 : 
                                500 
                            :
                                0
                            
                    )
                }
            }
            .onAppear(){
                cards = prepareCards(questions: questions, answers: answers)
                for _ in cards{
                    offsets.append(0)
                }
            }
        }
    }
}
