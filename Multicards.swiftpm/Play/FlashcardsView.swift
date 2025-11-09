import SwiftUI
struct Flashcards: Options{
    init() {}
    var shuffled = true
}
struct FlashcardsView: View {
    var fullCards: [Card]
    @State private var cards: [Card] = []
    var questions: [String]
    var answers: [String]
    @State private var tapped = false
    @State private var rotation = 0.0
    @State private var know: [Card] = []
    @State private var dontKnow: [Card] = []
    @State private var last: [Bool] = []
    @State private var count = 0
    var options: Flashcards
    var body: some View {
        GeometryReader{geometry in
            
            if Set(cards).isSubset(of: Set(know + dontKnow)){
                HStack{
                    Spacer()
                    VStack{
                        Spacer()
                        DonutChartView(total: Double(fullCards.count), know: Double(count))
                        Spacer()
                        Button("Try again"){
                            know = []
                            dontKnow = []
                            cards = fullCards
                            if options.shuffled{
                                cards.shuffle()
                            }
                            last = []
                            count = 0
                        }
                        .big()
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
                            .big()
                        }
                        Spacer()
                        
                            .onAppear(){
                                count += know.count
                            }
                    }
                    Spacer()
                }
                .frame(maxHeight: .infinity)
                .background(bg)
            }else{
                NavigationStack{
                    VStack{
                        Spacer()
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
                        .navigationTitle(String(cards.count-know.count-dontKnow.count)+" left")
                        ZStack {
                            ForEach(cards.reversed()) { card in
                                VStack{
                                    if tapped{
                                        ForEach(answers, id: \.self){ans in
                                            VStack{
                                                Text(ans)
                                                    .fontWeight(.medium)
                                                    .scaleEffect(x: -1, y: 1)
                                                    .minimumScaleFactor(0.2)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundStyle(accent)
                                                Text(card.sides[ans] ?? "")
                                                    .scaleEffect(x: -1, y: 1)
                                                    .minimumScaleFactor(0.2)
                                                    .multilineTextAlignment(.center)
                                            }
                                            .padding()
                                            if answers.last != ans{
                                                Divider()
                                            }
                                        }
                                        
                                    }else{
                                        ForEach(questions, id: \.self){que in
                                            VStack{
                                                Text(que)
                                                    .fontWeight(.medium)
                                                    .minimumScaleFactor(0.2)
                                                    .multilineTextAlignment(.center)
                                                    .foregroundStyle(accent)
                                                Text(card.sides[que] ?? "")
                                                    .minimumScaleFactor(0.2)
                                                    .multilineTextAlignment(.center)
                                            }
                                            .padding()
                                            if questions.last != que{
                                                Divider()
                                            }
                                        }
                                    }
                                }
                                .frame(width: 200, height: 400)
                                .background(back)
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
                                        -geometry.size.width :
                                            -geometry.size.width
                                        :
                                            dontKnow.contains(where: {$0.id==card.id}) ?
                                        tapped ?
                                        geometry.size.width :
                                            geometry.size.width
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
                        Spacer()
                    }
                    .background(bg)
                }
            }
        }
        .onAppear(){
            cards = fullCards
            if options.shuffled{
                cards.shuffle()
            }
        }
    }
}

#Preview {
    FlashcardsView(fullCards: [Card(sides: ["a":"b","c":"d"])], questions: ["a"], answers: ["c"], options: Flashcards())
        .preferredColorScheme(.dark)
}
