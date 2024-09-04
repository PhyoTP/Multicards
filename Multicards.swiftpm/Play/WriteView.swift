import SwiftUI

struct WriteView: View {
    @State var testingCards: [Card] = []
    @State var masteringCards: [Card] = []
    var questions: [Column]
    var answers: [Column]
    @State var currentCard = 0
    @State var givenAnswers: [String]
    @State var showAlert = false
    @State var alertDesc = "Wrong columns: "
    init(questions: [Column], answers: [Column]) {
        // Initialize the givenAnswers array with an empty string for each card
        let numCards = prepareCards(questions: questions, answers: answers).count
        _givenAnswers = State(initialValue: Array(repeating: "", count: numCards))
        
        self.questions = questions
        self.answers = answers
    }
    
    var body: some View {
        if currentCard < prepareCards(questions: questions, answers: answers).count {
            Form {
                Section{
                    ForEach(questions) { question in
                        Text(question.name + ": " + question.values[currentCard])
                    }
                    ForEach(answers.indices) { index in
                        HStack {
                            Text(answers[index].name + ":")
                            TextField("Answer", text: $givenAnswers[index])
                        }
                    }
                }
                Section{
                    Button("Check"){
                        for i in answers.indices{
                            if answers[i].values[currentCard].trimmingCharacters (in: .whitespaces) != givenAnswers[i].trimmingCharacters(in: .whitespaces) {
                                showAlert = true
                                alertDesc += answers[i].name + ", "
                            }
                        }
                        if showAlert{
                            alertDesc = String(alertDesc.dropLast(2))
                        }
                        
                    }
                }
            }
            .alert("Wrong answers", isPresented: $showAlert) {
                
                Button("I'm correct"){
                        
                }
                Button("Ok", role: .cancel){
                        
                }
                
            }message: {
                Text(alertDesc)
            }
        } else {
            // Handle when all cards have been processed
            Text("All cards completed!")
        }
    }
}
