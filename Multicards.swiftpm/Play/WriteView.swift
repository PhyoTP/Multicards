import SwiftUI
struct Write: Options{
    init() {}
    var caseSensitive = false
    var ignoreSpaces = true
    var shuffled = true
    var corrections = false
}
struct WriteView: View {
    @State private var cards: [Card] = []
    var questions: [Column]
    var answers: [Column]
    var question: Column {
        combineColumns(questions)
    }
    var answer: Column {
        combineColumns(answers)
    }
    @State private var know: [Card] = []
    @State private var dontKnow: [Card] = []
    @State private var done: [Card] = []
    @State private var texts: [String] = []
    @State private var showAlert = false
    @State private var wrongAnswers: [String] = []
    @State private var count = 0
    var options: Write
    var body: some View {
        Group {
            if Set(cards).isSubset(of: Set(done)) {
                VStack{
                    Spacer()
                    //DonutChartView(total: prepareCards(questions: questions, answers: answers).count, know: count)
                    Spacer()
                    
                    Button("Try again"){
                        know = []
                        dontKnow = []
                        cards = prepareCards(questions: questions, answers: answers)
                        done = []
                        count = 0
                    }
                    .frame(width: 200)
                    .padding()
                    .background(accent)
                    .foregroundStyle(.black)
                    .cornerRadius(10)
                    if !dontKnow.isEmpty{
                        Button("Try again with unknown"){
                            cards = dontKnow
                            know = []
                            dontKnow = []
                            done = []
                            print(dontKnow)
                        }
                        .frame(width: 200)
                        .padding()
                        .background(accent)
                        .foregroundStyle(.black)
                        .cornerRadius(10)
                        
                    }
                    Spacer()
                }
                .onAppear(){
                    count += know.count
                }
            } else {
                Text(String(done.count)+"/"+String(cards.count))
                ZStack {
                    //todo: remove zstack
                    ForEach(cards.reversed()) { card in
                        Form {
                            Section("Questions") {
                                Text(question.name)
                                Text(card.sides[question.name] ?? "")
                            }
                            Section("Answers") {
                                ForEach(answers.indices, id: \.self) { index in
                                    HStack {
                                        Text(answers[index].name)
                                        TextField("Enter", text: $texts[index])
                                    }
                                }
                                Button("Submit"){
                                    var wrongAnswersLocal: [String] = []
                                    for (index, text) in texts.enumerated() {
                                        var input = text
                                        var correctAnswer = card.sides[answers[index].name] ?? ""
                                        if options.ignoreSpaces{
                                            input = input.trimmingCharacters(in: .whitespacesAndNewlines)
                                            correctAnswer = correctAnswer.trimmingCharacters(in: .whitespacesAndNewlines)
                                        }
                                        if !options.caseSensitive{
                                            input = input.lowercased()
                                            correctAnswer = correctAnswer.lowercased()
                                        }
                                        
                                        if input != correctAnswer {
                                            wrongAnswersLocal.append("\(answers[index].name): \(correctAnswer)")
                                        }
                                    }
                                    
                                    if wrongAnswersLocal.isEmpty {
                                        know.append(card)
                                    } else {
                                        wrongAnswers = wrongAnswersLocal
                                        showAlert = true
                                    }
                                    
                                    done.append(card)
                                    texts = Array(repeating: "", count: answers.count)
                                }
                                .alert("Wrong answer", isPresented: $showAlert) {
                                    Button("I'm correct") {
                                        know.append(card)
                                    }
                                    Button("Ok", role: .cancel) {
                                        dontKnow.append(card)
                                    }
                                } message: {
                                    if !wrongAnswers.isEmpty {
                                        Text("Incorrect Answers:\n" + wrongAnswers.joined(separator: "\n"))
                                    }
                                }
                            }
                        }
                        .opacity(done.contains(where: { $0.id == card.id }) ? 0 : 1)
                    }
                }
            }
        }
        .onAppear() {
            cards = prepareCards(questions: questions, answers: answers)
            texts = Array(repeating: "", count: answers.count)
            if options.shuffled{
                cards.shuffle()
            }
        }
    }
}
