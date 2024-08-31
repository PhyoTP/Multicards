import SwiftUI

struct PlayView: View {
    var set: CardSet
    @State var questionSelected: [Column] = []
    @State var answerSelected: [Column] = []
    @State var showAlert = false
    @State var alertDesc = ""
    @State var flashcards = false
    @State var match = false
    @State var write = false
    var body: some View {
        NavigationStack{
            Form {
                Section {
                    Menu("Question cards") {
                        ForEach(set.convertToColumns()){column in
                            if questionSelected.contains(where: {$0.name == column.name}){
                                
                                Button{
                                    
                                    questionSelected.removeAll(where: {$0.name == column.name})
                                    print(questionSelected)
                                    
                                }label: {
                                    Text(column.name)
                                    Image(systemName: "checkmark")
                                }
                                
                                
                            }else{
                                Button(column.name){
                                    questionSelected.append(column)
                                    print(questionSelected)
                                }
                            }
                        }
                    }
                    ForEach(questionSelected){column in
                        Text(column.name) 
                    }
                    Menu("Answer cards") {
                        ForEach(set.convertToColumns()){column in
                            if answerSelected.contains(where: {$0.name == column.name}){
                                
                                Button{
                                    
                                    answerSelected.removeAll(where: {$0.name == column.name})
                                    print(answerSelected)
                                    
                                }label: {
                                    Text(column.name)
                                    Image(systemName: "checkmark")
                                }
                                
                                
                            }else{
                                Button(column.name){
                                    answerSelected.append(column)
                                    print(answerSelected)
                                }
                            }
                        }
                    }
                    ForEach(answerSelected){column in
                        Text(column.name) 
                    }
                }
                
                
                
                
                Section("Mode") {
                    Button{
                        if questionSelected.isEmpty || answerSelected.isEmpty{
                            showAlert = true
                            alertDesc = "Card sides cannot be empty"
                        }else{
                            flashcards = true
                        }
                    }label: {
                        Label("Flashcards", systemImage: "rectangle.stack")
                    }
                    
                        Button{
                            if questionSelected.isEmpty || answerSelected.isEmpty{
                                showAlert = true
                                alertDesc = "Card sides cannot be empty"
                            }else{
                                match = true
                            }
                        }label: {
                            Label("Match", systemImage: "rectangle.grid.3x2")
                        }
                    
                    Button{
                        if questionSelected.isEmpty || answerSelected.isEmpty{
                            showAlert = true
                            alertDesc = "Card sides cannot be empty"
                        }else{
                            write = true
                        }
                    }label: {
                        Label("Write", systemImage: "rectangle.and.pencil.and.ellipsis")
                    }
                }
            }
            .navigationTitle("Play")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Error"), message: Text(alertDesc), dismissButton: .default(Text("OK")))
            }
            .sheet(isPresented: $flashcards) {
                FlashcardsView(questions: questionSelected, answers: answerSelected)
            }
            .sheet(isPresented: $match) {
                MatchView(questions: questionSelected, answers: answerSelected)
            }
            .sheet(isPresented: $write) {
                WriteView(cards: prepareCards(questions: questionSelected, answers: answerSelected))
            }
        }
    }
}
