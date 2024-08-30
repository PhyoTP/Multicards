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
    @State var know: [Card] = []
    @State var dontKnow: [Card] = []
    @State var last: [Bool] = []
    @Environment(\.dismiss) var dismiss
    var body: some View {
        Group{
            if Set(cards).isSubset(of: Set(know + dontKnow)){
                VStack{
                    Button("Close"){
                        dismiss()
                    }
                    .frame(width: 200)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    Button("Try again"){
                        know = []
                        dontKnow = []
                        cards = prepareCards(questions: questions, answers: answers)
                    }
                    .frame(width: 200)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    if !dontKnow.isEmpty{
                        Button("Try again with unknown"){
                            cards = dontKnow
                            know = []
                            dontKnow = []
                        }
                        .frame(width: 200)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                    }
                }
            }else{
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
                                                last.append(true)
                                                                                   }
                                            
                                        }
                                        if value.translation.width > 0{
                                            withAnimation(){
                                                dontKnow.append(card)
                                                last.append(false)
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
                    if !last.isEmpty{
                        Button("Undo", systemImage: "arrow.counterclockwise") {
                            withAnimation {
                                if last.last ?? true && !know.isEmpty {
                                    know.remove(at: know.count - 1)
                                    last.remove(at: last.count-1)
                                } else if !dontKnow.isEmpty {
                                    dontKnow.remove(at: dontKnow.count - 1)
                                    last.remove(at: last.count-1)
                                }
                            }
                        }
                        
                    }
                }
            }
        }
        .onAppear(){
            cards = prepareCards(questions: questions, answers: answers)
        }
    }
}
