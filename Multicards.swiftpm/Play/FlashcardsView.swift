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
                        last = []
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
                            last = []
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
                            .mask{
                                RoundedRectangle(cornerRadius: 20)
                            }
                            .gesture(
                                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                                    .onEnded({value in
                                        if value.translation.width < 0{
                                            withAnimation(){
                                                if tapped{
                                                    dontKnow.append(card)
                                                    last.append(false)
                                                }else{
                                                    know.append(card)
                                                    last.append(true)
                                                }
                                                
                                                                                            }
                                            tapped = false
                                            rotation = 0
                                        }
                                        if value.translation.width > 0{
                                            withAnimation(){
                                                if tapped{
                                                    know.append(card)
                                                    last.append(true)
                                                }else{
                                                    dontKnow.append(card)
                                                    last.append(false)
                                                }
                                                
                                                                                            }
                                            tapped = false
                                            rotation = 0
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
                                        -500 :
                                        -500 
                                    : 
                                    dontKnow.contains(where: {$0.id==card.id}) ?
                                        tapped ? 
                                            500 : 
                                            500 
                                        :
                                        0
                                    
                            )
                        }
                    }
                    if !last.isEmpty{
                        Button("Undo", systemImage: "arrow.counterclockwise") {
                            withAnimation {
                                if last.last == true && !know.isEmpty {
                                    know.remove(at: know.count - 1)
                                    last.remove(at: last.count-1)
                                }else if last.last == false && !dontKnow.isEmpty {
                                    dontKnow.remove(at: dontKnow.count - 1)
                                    last.remove(at: last.count-1)
                                }
                                print(last)
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
