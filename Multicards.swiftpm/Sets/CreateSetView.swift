import SwiftUI

struct CreateSetView: View {
    @State var set: CardSet = CardSet(name: "", cards: [Card(sides: ["": ""])], creator: "", isPublic: false)
    @Environment(\.dismiss) var dismiss
    @State var showSheet = false
    @State private var columns: [Column] = [Column(name: "", values: [""]),Column(name: "", values: [""])]
    var userData: UserData
    @State var showAlert = false
    @State var alertDesc = ""
    var localSetsManager: LocalSetsManager
    var setsManager = SetsManager()
    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $set.name)
                if userData.isLoggedIn {
                    Toggle("Make Public", isOn: $set.isPublic)
                }
            }
            
            Section(header:Text("Table"), footer:
                        Button("Import", systemImage: "square.and.arrow.down") {
                showSheet = true
                
            }
            ) {
                GridView(columns: $columns)
                
            }
            
            Section {
                Button("Create") {
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
                        localSetsManager.localSets.append(set)
                        dismiss()
                        localSetsManager.sync()
                        if set.isPublic{
                            setsManager.postSet(set)
                        }
                        setsManager.getSets()
                        
                    }
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
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertDesc), dismissButton: .default(Text("OK")))
        }
    }
}
#Preview{
    CreateSetView(userData: UserData(), localSetsManager: LocalSetsManager())
        .preferredColorScheme(.light)
}
