import SwiftUI
enum Gamemode: String{
    case Flashcards, Match, Write
}
protocol Options{ init() }
func bindOption<T: Options>(options: Binding<Options?>, as type: T.Type) -> Binding<T> {
    return Binding<T>(
        get: {
            (options.wrappedValue as? T) ?? T.init()
        },
        set: { newValue in
            options.wrappedValue = newValue
        }
    )
}
struct PlayView: View {
    var set: CardSet
    @State private var questionSelected: [Column] = []
    @State private var answerSelected: [Column] = []
    @State private var gamemode: Gamemode?
    @State private var options: (any Options)?
    var body: some View {
        NavigationStack{
            Form {
                Section("Sides"){
                    ZStack{
                        HStack{
                            Text("")
                            Spacer()
                            Text("Question")
                                .bold()
                            Spacer()
                        }
                        HStack{
                            Spacer()
                            Text("Answer")
                                .bold()
                        }
                    }
                    List(set.convertToColumns()){column in
                        ZStack{
                            HStack{
                                Spacer()
                                if questionSelected.contains(where: {$0.name == column.name}){
                                    
                                    Button{
                                        
                                        questionSelected.removeAll(where: {$0.name == column.name})
                                        
                                        
                                    }label: {
                                        Image(systemName: "checkmark.square.fill")
                                    }
                                    .buttonStyle(.plain)
                                    
                                }else{
                                    Button{
                                        questionSelected.append(column)
                                        
                                    }label:{
                                        Image(systemName: "square")
                                    }
                                    .buttonStyle(.plain)
                                }
                                Spacer()
                            }
                            HStack{
                                Text(column.name)
                                Spacer()
                                if answerSelected.contains(where: {$0.name == column.name}){
                                    
                                    Button{
                                        
                                        answerSelected.removeAll(where: {$0.name == column.name})
                                        
                                        
                                    }label: {
                                        Image(systemName: "checkmark.square.fill")
                                    }
                                    .buttonStyle(.plain)
                                    
                                }else{
                                    Button{
                                        answerSelected.append(column)
                                        
                                    }label:{
                                        Image(systemName: "square")
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }
                    
                    
                    
                    
                    
                    
                }
                
                Section("Mode"){
                    
                    Menu(gamemode?.rawValue ?? "Select a mode") {
                        Button{
                            gamemode = .Flashcards
                            options = Flashcards()
                        }label:{
                            Label("Flashcards", systemImage: "rectangle.stack")
                        }
                        .disabled(questionSelected.isEmpty || answerSelected.isEmpty)
                        Button{
                            gamemode = .Match
                            options = Match()
                        }label:{
                            Label("Match", systemImage: "rectangle.grid.3x2")
                        }
                        .disabled(questionSelected.isEmpty || answerSelected.isEmpty)
                        Button{
                            gamemode = .Write
                            options = Write()
                        }label:{
                            Label("Write", systemImage: "rectangle.and.pencil.and.ellipsis")
                        }
                        .disabled(questionSelected.isEmpty || answerSelected.isEmpty)
                        
                    }
                    
                    if let _ = options as? Flashcards {
                        Toggle("Shuffled?", isOn: bindOption(options: $options, as: Flashcards.self).shuffled)
                    }else if let _ = options as? Write {
                        Toggle("Shuffled?", isOn: bindOption(options: $options, as: Write.self).shuffled)
                        Toggle("Case-sensitive?", isOn: bindOption(options: $options, as: Write.self).caseSensitive)
                        Toggle("Ignore spaces?", isOn: bindOption(options: $options, as: Write.self).ignoreSpaces)
                    }
                }
                Section{
                    if let selectedGamemode = gamemode{
                        NavigationLink{
                            switch selectedGamemode {
                            case .Flashcards:
                                FlashcardsView(fullCards: set.cards, questions: questionSelected.map{$0.name}, answers: answerSelected.map{$0.name}, options: options as? Flashcards ?? Flashcards())
                                    
                            case .Match:
                                MatchView(questions: questionSelected, answers: answerSelected, options: options as? Match ?? Match())
                                    
                            case .Write:
                                WriteView(questions: questionSelected, answers: answerSelected, options: options as? Write ?? Write())
                                    
                            }
                        }label: {
                            Label("Play", systemImage: "play.fill")
                        }
                    }
                }
            }
            .navigationTitle("Play")
        }
    }
}
