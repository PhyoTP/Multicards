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
                    List(set.convertToColumns()) { column in
                        ZStack {
                            HStack {
                                Spacer()
                                CheckmarkView(
                                    toggled: Binding(
                                        get: { questionSelected.contains(where: { $0.name == column.name }) },
                                        set: { isOn in
                                            if isOn {
                                                questionSelected.append(column)
                                            } else {
                                                questionSelected.removeAll { $0.name == column.name }
                                            }
                                        }
                                    )
                                )
                                Spacer()
                            }
                            HStack {
                                Text(column.name)
                                Spacer()
                                CheckmarkView(
                                    toggled: Binding(
                                        get: { answerSelected.contains(where: { $0.name == column.name }) },
                                        set: { isOn in
                                            if isOn {
                                                answerSelected.append(column)
                                            } else {
                                                answerSelected.removeAll { $0.name == column.name }
                                            }
                                        }
                                    )
                                )
                            }
                        }
                    }

                }
                .listRowBackground(back)
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
                            options = NewWrite()
                        }label:{
                            Label("Write", systemImage: "rectangle.and.pencil.and.ellipsis")
                        }
                        .disabled(questionSelected.isEmpty || answerSelected.isEmpty)
                        
                    }
                    
                    if let _ = options as? Flashcards {
                        Toggle("Shuffled?", isOn: bindOption(options: $options, as: Flashcards.self).shuffled)
                    }else if let _ = options as? NewWrite {
                        Toggle("Shuffled?", isOn: bindOption(options: $options, as: NewWrite.self).shuffled)
                        Toggle("Case-sensitive?", isOn: bindOption(options: $options, as: NewWrite.self).caseSensitive)
                        Toggle("Ignore spaces?", isOn: bindOption(options: $options, as: NewWrite.self).ignoreSpaces)
                    }
                }
                .listRowBackground(back)
                Section{
                    if let selectedGamemode = gamemode{
                        NavigationLink{
                            switch selectedGamemode {
                            case .Flashcards:
                                FlashcardsView(fullCards: set.cards, questions: questionSelected.map{$0.name}, answers: answerSelected.map{$0.name}, options: options as? Flashcards ?? Flashcards())
                                
                            case .Match:
                                MatchView(questions: questionSelected, answers: answerSelected, options: options as? Match ?? Match())
                                
                            case .Write:
                                NewWriteView(fullCards: set.cards, questions: questionSelected.map{$0.name}, answers: answerSelected.map{$0.name}, options: options as? NewWrite ?? NewWrite())
                                
                            }
                        }label: {
                            Label("Play", systemImage: "play.fill")
                        }
                    }
                }
                .listRowBackground(back)
            }
            .navigationTitle("Play")
            .unifiedBackground()
        }
    }
}
struct CheckmarkView: View {
    @Binding var toggled: Bool
    
    var body: some View {
        Button {
            withAnimation(.spring()) {
                toggled.toggle()
            }
        } label: {
            Image(systemName: toggled ? "checkmark.square.fill" : "square")
                .symbolRenderingMode(.palette)
                .foregroundStyle(.white, accent)
        }
        .buttonStyle(.plain)
        .contentTransition(.symbolEffect(.replace))
    }
}
#Preview {
    @Previewable @State var toggled: Bool = false
    CheckmarkView(
        toggled: $toggled
    )
    .preferredColorScheme(.dark)
}
