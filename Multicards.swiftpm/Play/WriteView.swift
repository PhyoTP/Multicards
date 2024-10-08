import SwiftUI

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
    @Environment(\.dismiss) var dismiss
    @State private var texts: [String] = []
    @State private var showAlert = false
    @State private var wrongAnswers: [String] = []
    @State private var count = 0
    var body: some View {
        Group {
            if Set(cards).isSubset(of: Set(know + dontKnow)) {
                VStack{
                    Spacer()
                    DonutChartView(total: prepareCards(questions: questions, answers: answers).count, know: count)
                    Spacer()
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
                        done = []
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
                            know = []
                            dontKnow = []
                            done = []
                        }
                        .frame(width: 200)
                        .padding()
                        .background(.blue)
                        .foregroundStyle(.white)
                        .cornerRadius(10)
                        
                    }
                    Spacer()
                }
                .onAppear(){
                    count += know.count
                }
            } else {
                ZStack {
                    ForEach(cards) { card in
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
                            }
                            Section {
                                Button("Submit") {
                                    var wrongAnswersLocal: [String] = []
                                    for (index, text) in texts.enumerated() {
                                        let trimmedInput = text.trimmingCharacters(in: .whitespacesAndNewlines)
                                        let correctAnswer = card.sides[answers[index].name]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
                                        
                                        if trimmedInput != correctAnswer {
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
        }
    }
}
