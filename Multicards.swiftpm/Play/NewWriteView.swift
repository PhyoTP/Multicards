import SwiftUI

struct NewWrite: Options{
    init() {}
    var caseSensitive = false
    var ignoreSpaces = true
    var shuffled = true
    var corrections = false
}
struct NewWriteView: View{
    var fullCards: [Card]
    @State private var cards: [Card] = []
    var questions: [String]
    var answers: [String]
    @State private var ansInputs: [String: String] = [:]
    var options: NewWrite
    @State private var dontKnow: [Card] = []
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var done = false
    @State private var checkOpacity = 0.0
    var body: some View{
        if done{
            VStack{
                Spacer()
                DonutChartView(total: Double(fullCards.count), know: Double(fullCards.count-dontKnow.count))
                Spacer()
                Button("Restart"){
                    cards = fullCards
                    dontKnow = []
                    done = false
                }
                .big()
                if !dontKnow.isEmpty{
                    Button("Restart with unknown"){
                        print(dontKnow)
                        cards = dontKnow
                        dontKnow = []
                        done = false
                        print(cards)
                    }
                    .big()
                }
                Spacer()
            }
        }else{
            ZStack{
                NavigationStack{
                    Form{
                        Section("Question"){
                            ForEach(questions, id: \.self){ question in
                                HStack{
                                    Text(question+":")
                                        .fontWeight(.medium)
                                    if let first = cards.first{
                                        Text(first.sides[question] ?? "")
                                    }
                                }
                            }
                        }
                        .listRowBackground(back)
                        Section("Answers"){
                            ForEach(answers, id: \.self){answer in
                                HStack{
                                    Text(answer+":")
                                        .fontWeight(.medium)
                                    TextField("Answer", text: binding(for: answer))
                                }
                            }
                        }
                        .listRowBackground(back)
                    }
                    .onAppear(){
                        if cards.isEmpty{
                            cards = fullCards
                        }
                        if options.shuffled{
                            cards.shuffle()
                        }
                        ansInputs = Dictionary(uniqueKeysWithValues: answers.map{($0, "")})
                    }
                    .alert("Wrong!",isPresented: $showAlert){
                        Button("Ok"){
                            dontKnow.append(cards[0])
                            cards.removeFirst()
                            if cards.isEmpty{
                                done = true
                            }
                        }
                        Button("I'm correct"){
                            cards.removeFirst()
                            if cards.isEmpty{
                                done = true
                            }
                        }
                    }message:{
                        Text(alertMessage)
                    }
                    .toolbar{
                        ToolbarItem(placement: .topBarLeading) { 
                            Text("Question \(fullCards.count - cards.count + 1)/\(fullCards.count)")
                                .fontWeight(.medium)
                        }
                        ToolbarItem(placement: .topBarTrailing) { 
                            Button("Submit"){
                                var wrong: [String] = []
                                for i in answers{
                                    var ansInput = ansInputs[i] ?? ""
                                    var answer = cards.first?.sides[i] ?? ""
                                    if !options.caseSensitive{
                                        ansInput = ansInput.lowercased()
                                        answer = answer.lowercased()
                                    }
                                    if options.ignoreSpaces{
                                        ansInput = ansInput.replacingOccurrences(of: " ", with: "")
                                        answer = answer.replacingOccurrences(of: " ", with: "")
                                    }else{
                                        ansInput = ansInput.trimmingCharacters(in:.whitespacesAndNewlines)
                                        answer = answer.trimmingCharacters(in:.whitespacesAndNewlines)
                                    }
                                    print(ansInput)
                                    print(answer)
                                    if ansInput != answer{
                                        wrong.append(i)
                                    }
                                }
                                if !wrong.isEmpty{
                                    showAlert = true
                                    alertMessage = wrong.map{$0 + ": " + String(cards.first?.sides[$0] ?? "")}.joined(separator:"\n")
                                    
                                }else{
                                    cards.removeFirst()
                                    if cards.isEmpty{
                                        done = true
                                    }
                                    withAnimation(.easeIn(duration: 0.2)) {
                                        checkOpacity = 1.0
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            checkOpacity = 0.0
                                        }
                                    }
                                }
                                
                                ansInputs = Dictionary(uniqueKeysWithValues: answers.map{($0, "")})
                            }
                        }
                    }
                    .unifiedBackground()
                }
                .sensoryFeedback(.error, trigger: showAlert)
                .sensoryFeedback(.success, trigger: checkOpacity == 1.0)
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.largeTitle)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .mask{RoundedRectangle(cornerRadius: 25)}
                    .opacity(checkOpacity)
            }
        }
    }
    private func binding(for key: String) -> Binding<String> {
        Binding(
            get: { ansInputs[key] ?? "" },
            set: { ansInputs[key] = $0 }
        )
    }
}
#Preview{
    NewWriteView(fullCards: [Card(sides: ["a":"b","c":"d"])], questions: ["a"], answers: ["c"], options: NewWrite())
}
