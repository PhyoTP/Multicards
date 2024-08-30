import SwiftUI

struct PlayView: View {
    var set: CardSet
    @State var questionSelected: [Column] = []
    @State var answerSelected: [Column] = []
    @State var questionSelectable: [Column] = []
    @State var answerSelectable: [Column] = []
    var body: some View {
        Form {
            Section {
                Menu("Question cards") {
                    ForEach(questionSelectable) { column in
                        
                            if questionSelected.contains(column) {
                                
                                    Button{
                                        if let index = questionSelected.firstIndex(where: { $0.id == column.id }) {
                                            questionSelected.remove(at: index)
                                        }
                                    }label: {
                                        Text(column.name)
                                        Image(systemName: "checkmark")
                                    }
                                                                    
                            } else {
                                Button(column.name) {
                                    questionSelected.append(column)
                                }
                            }
                        
                    }
                    .onAppear {
                        questionSelectable = set.convertToColumns().filter { !answerSelected.contains($0) }
                    }
                }
                .onAppear {
                    questionSelectable = set.convertToColumns().filter { !answerSelected.contains($0) }
                }
            }
            
            Menu("Answer cards") {
                ForEach(answerSelectable) { column in
                    
                        if answerSelected.contains(column) {
                            
                            Button{
                                    if let index = answerSelected.firstIndex(where: { $0.id == column.id }) {
                                        answerSelected.remove(at: index)
                                    }
                                }label:{
                                    Text(column.name)
                                    Image(systemName: "checkmark")
                                }
                            
                        } else {
                            Button(column.name) {
                                answerSelected.append(column)
                            }
                        }
                    
                }
                .onAppear {
                    answerSelectable = set.convertToColumns().filter { !questionSelected.contains($0) }
                }
            }
            .onAppear {
                answerSelectable = set.convertToColumns().filter { !questionSelected.contains($0) }
            }
            
            
            Section("Mode") {
                // Add other controls
            }
        }
    }
}
