import SwiftUI

struct WriteView: View {
    @State var masteringQuestions: [Column] = []
    @State var masteringAnswers: [Column] = []
    var questions: [Column]
    var answers: [Column]
    @State var currentCard = 0
    @State var givenAnswers: [String]
    @State var showAlert = false
    @State var alertDesc = ""
    init(questions: [Column], answers: [Column]) {
        // Initialize the givenAnswers array with an empty string for each card
        givenAnswers = Array(repeating: "", count: questions[0].values.count)
        
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
                            if answers[i].values[currentCard].trimmingCharacters(in: .whitespaces) != givenAnswers[i].trimmingCharacters(in: .whitespaces) {
                                showAlert = true
                                alertDesc += answers[i].name + ": " + answers[i].values[currentCard] + "\n"
                            }
                        }
                        if showAlert{
                            alertDesc = String(alertDesc.dropLast(1))
                        }else{
                         
                            currentCard += 1
                            givenAnswers = Array(repeating: "", count: questions[0].values.count)
                            
                        }
                        
                    }
                }
            }
            .alert("Wrong answers", isPresented: $showAlert) {
                
                Button("I'm correct"){
                    currentCard += 1
                    alertDesc = ""
                    givenAnswers = Array(repeating: "", count: questions[0].values.count)
                }
                Button("Ok", role: .cancel){
                    currentCard += 1
                    alertDesc = ""
                    givenAnswers = Array(repeating: "", count: questions[0].values.count)
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
