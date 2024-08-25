import SwiftUI

struct CreateSetView: View {
    @State var set: CardSet = CardSet(name: "", cards: [Card(sides: ["": ""])], creator: "", isPublic: false)
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var showSheet = false
    
    // State variable to manage the keys
    @State private var columns: [Column] = []
    
    var userData: UserData
    
    var body: some View {
        Form {
            Section {
                Button("Import", systemImage: "square.and.arrow.down") {
                    showSheet = true
                }
            }
            
            // Title section
            TextField("Title", text: $set.name)
            
            Section("Table") {
                ScrollView(.horizontal) {
                    Grid{
                        
                        ForEach($columns){$column in
                            GridRow{
                                TextField("Dimension",text: $column.name)
                                ForEach($column.values, id: \.self){$value in
                                    TextField("Value", text: $value)
                                }
                            } 
                        }
                    }
                }
            }
            
            Section {
                Button("Create") {
                    
                }
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showSheet) {
            ImportView(result: $columns)
        }
    }
    
}
