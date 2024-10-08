import SwiftUI

struct ImportView: View{
    @State private var text = ""
    @State private var selectedTermSeparator = TermSeparator.tab
    @State private var selectedCardSeparator = CardSeparator.newline
    @Environment(\.dismiss) var dismiss
    @Binding var result: [Column]
    var body: some View{
        Form{
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
                Button("Import"){
                    result = convertStringToColumns(input: text, termSeparator: selectedTermSeparator, cardSeparator: selectedCardSeparator)
                    dismiss()
                    
                }
                Button("Cancel", role: .destructive){
                    dismiss()
                }
            }
        }
    }
}
