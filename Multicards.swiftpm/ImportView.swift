import SwiftUI

struct ImportView: View{
    @State var title = ""
    @State var isPublic = true
    @State var text = ""
    @State var selectedTermSeparator = TermSeparator.tab
    @State var selectedCardSeparator = CardSeparator.newline
    var userData: UserData
    @Environment(\.dismiss) var dismiss
    @State var result = Set(name: "", cards: [], creator: "")
    var body: some View{
        Form{
            Section("Details"){
                TextField("Title",text: $title)
                Toggle(isOn: $isPublic){
                    Text("Set Public")
                }
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
                Button("Create"){
                    result = convertStringToSet(input: text, termSeparator: selectedTermSeparator, cardSeparator: selectedCardSeparator, title: title, creator: userData.name)
                    
                }
                Button("Cancel", role: .destructive){
                    dismiss()
                }
            }
        }
    }
}
