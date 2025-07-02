import SwiftUI
struct Flashcards: Options{
    init() {}
    var shuffled = true
}
struct FlashcardsView: View {
    @State private var cards: [Card] = []
    var questions: [Column]
    var answers: [Column]
    var question: Column {
        combineColumns(questions)
    }
    var answer: Column {
        combineColumns(answers)
    }
    @State private var tapped = false
    @State private var rotation = 0.0
    @State private var know: [Card] = []
    @State private var dontKnow: [Card] = []
    @State private var last: [Bool] = []
    @State private var count = 0
    var options: Flashcards
    var body: some View {
        VStack{
            if Set(cards).isSubset(of: Set(know + dontKnow)){
                    Spacer()
                    DonutChartView(total: prepareCards(questions: questions, answers: answers).count, know: count)
                    Spacer()
                    Button("Try again"){
                        know = []
                        dontKnow = []
                        cards = prepareCards(questions: questions, answers: answers)
                        if options.shuffled{
                            cards.shuffle()
                        }
                        last = []
                        count = 0
                    }
                    .frame(width: 200)
                    .padding()
                    .background(.blue)
                    .foregroundStyle(.white)
                    .cornerRadius(10)
                    if !dontKnow.isEmpty{
                        Button("Try again with unknown"){
                            cards = dontKnow
                            if options.shuffled{
                                cards.shuffle()
                            }
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
                    Spacer()
                
                .onAppear(){
                    count += know.count
                }
            }else{
                
                    HStack{
                        Spacer()
                        Image(systemName: "arrow.left")
                        Text(String(know.count))
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundStyle(.green)
                            .font(.system(size: 30))
                        Spacer()
                        Image(systemName: "multiply.circle.fill")
                            .foregroundStyle(.red)
                            .font(.system(size: 30))
                        Text(String(dontKnow.count))
                        Image(systemName: "arrow.right")
                        Spacer()
                    }
                    ZStack {
                        ForEach(cards.reversed()) { card in
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
                            .background(Color(.systemGray4))
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
        .onAppear(){
            cards = prepareCards(questions: questions, answers: answers)
            if options.shuffled{
                cards.shuffle()
            }
        }
    }
}
