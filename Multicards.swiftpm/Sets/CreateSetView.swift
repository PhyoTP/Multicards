import SwiftUI

struct CreateSetView: View {
    @State private var set: CardSet = CardSet(name: "", cards: [Card(sides: ["": ""])], creator: "", isPublic: false, tags: [])
    @Environment(\.dismiss) var dismiss
    @State private var showSheet = false
    @State private var columns: [Column] = [Column(name: "", values: [""]),Column(name: "", values: [""])]
    @EnvironmentObject var userData: UserData
    @State private var showAlert = false
    @State private var alertDesc = ""
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @EnvironmentObject var setsManager: SetsManager
    @State private var tagsText = ""
    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $set.name)
                if userData.isLoggedIn {
                    Toggle("Make Public", isOn: $set.isPublic)
                }
//                HStack{
//                    Text("Tags: ")
//                    TextField("Seperate with commas", text: Binding(get: { 
//                        return tagsText
//                    }, set: { newText in
//                        if newText.contains(","){
//                            let newTags = newText.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
//                            let totalTags = (set.tags ?? []) + newTags
//                            set.tags = totalTags
//                            tagsText = ""
//                        }
//                    }))
//                }
            }
            .listRowBackground(back)
            Section(header:Text("Table"), footer:
                Button("Import", systemImage: "square.and.arrow.down") {
                    showSheet = true
                }
            ) {
                GridView(columns: $columns)
                
            }
            .listRowBackground(back)
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
            .listRowBackground(back)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .sheet(isPresented: $showSheet) {
            ImportView(result: $columns)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertDesc), dismissButton: .default(Text("OK")))
        }
        .unifiedBackground()
    }
}

