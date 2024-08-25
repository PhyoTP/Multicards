import SwiftUI

struct ImportView: View{
    @State var title = ""
    @State var text = ""
    @State var selectedTermSeparator = TermSeparator.tab
    @State var selectedCardSeparator = CardSeparator.newline
    var userData: UserData
    var localSetsManager: LocalSetsManager
    var setsManager = SetsManager()
    @Environment(\.dismiss) var dismiss
    @State var result = CardSet(name: "", cards: [], creator: "", isPublic: false)
    @State var showError = false
    @State var errorDesc = ""
    @State var showSheet = false
    var body: some View{
        Form{
            Section("Details"){
                TextField("Title",text: $title)
            }
            Section("set"){
                Picker("Term Separator", selection: $selectedTermSeparator) {
                    ForEach(TermSeparator.allCases, id: \.self) { separator in
                        Text(separator.rawValue == "\t" ? "Tab" : "Comma").tag(separator)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                
                // Picker for card separator
                Picker("Card Separator", selection: $selectedCardSeparator) {
                    ForEach(CardSeparator.allCases, id: \.self) { separator in
                        Text(separator.rawValue == "\n" ? "Newline" : "Semicolon").tag(separator)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                TextField("Paste here", text: $text, axis: .vertical)
            }
            Section{
                Button("Convert"){
                    result = convertStringToSet(input: text, termSeparator: selectedTermSeparator, cardSeparator: selectedCardSeparator, title: title, creator: userData.name)
                    showSheet = true
                    
                }
                Button("Cancel", role: .destructive){
                    dismiss()
                }
            }
        }
        .alert("An error occured", isPresented: $showError){
            
        }
        .sheet(isPresented: $showSheet){
            EditSetView(set: result, create: true)
        }
    }
}
