import SwiftUI

struct EditSetView: View {
    @Binding var set: CardSet
    @Environment(\.dismiss) var dismiss
    @State private var columns: [Column] = [Column(name: "", values: [""]),Column(name: "", values: [""])]
    var userData: UserData
    @State var showAlert = false
    @State var alertDesc = ""
    var localSetsManager: LocalSetsManager
    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $set.name)
                if userData.isLoggedIn {
                    Toggle("Public", isOn: $set.isPublic)
                }
            }
            
            Section("Table") {
                
                GridView(columns: $columns)
            }
            .onAppear(){
                columns = set.convertToColumns()
            }
            Section {
                Button("Save") {
                    let names = columns.map { $0.name }
                    if set.name.isEmpty {
                        showAlert = true
                        alertDesc = "Title cannot be blank"
                    } else if names.contains("") {
                        showAlert = true
                        alertDesc = "Dimension name cannot be blank"
                    } else if numCards(columns) == 0{
                        showAlert = true
                        alertDesc = "Must have at least one card"
                    } else {
                        set.convertColumns(columns)
                        set.creator = userData.name
                        dismiss()
                        localSetsManager.sync()
                        if set.isPublic{
                            localSetsManager.updateSet(set)
                        }
                        
                        
                    }
                }
                Button("Cancel", role: .destructive) {
                    dismiss()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertDesc), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview{
    EditSetView(set: .constant(CardSet(name: "", cards: [], creator: "", isPublic: true)), userData: UserData(), localSetsManager: LocalSetsManager())
}
