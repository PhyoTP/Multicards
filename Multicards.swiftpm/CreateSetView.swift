import SwiftUI

struct CreateSetView: View {
    @State var set: CardSet = CardSet(name: "", cards: [Card(sides: ["": ""])], creator: "", isPublic: false)
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var showSheet = false
    @State private var columns: [Column] = [Column(name: "", values: [""]),Column(name: "", values: [""])]
    var userData: UserData
    @State var showAlert = false
    @State var alertDesc = ""
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $set.name)
                if userData.isLoggedIn {
                    Toggle("Make Public", isOn: $set.isPublic)
                }
            }
            
            Section("Table") {
                Button("Import", systemImage: "square.and.arrow.down") {
                    showSheet = true
                }
                
                ScrollView(.horizontal) {
                    HStack {
                        Grid {
                            ForEach($columns) { $column in
                                GridRow {
                                    TextField("Dimension", text: $column.name)
                                        .fontWeight(.medium)
                                    if columns.firstIndex(where: { $0.id == column.id })! > 1 {
                                        Button {
                                            if let index = columns.firstIndex(where: { $0.id == column.id }) {
                                                columns.remove(at: index)
                                            }
                                        } label: {
                                            Image(systemName: "minus.circle.fill")
                                                .foregroundStyle(.red)
                                        }
                                    }else{
                                        Button{
                                            
                                        }label:{
                                            Image(systemName: "minus.circle")
                                                .foregroundStyle(.clear)
                                        }
                                    }
                                    
                                    Rectangle()
                                        .fill(Color(uiColor: .systemGray3))
                                        .frame(width: 3)
                                    
                                    ForEach($column.values.indices, id: \.self) { index in
                                        TextField("Value", text: $column.values[index])
                                        HStack { Divider() }
                                    }
                                }
                                Divider()
                            }
                            
                            GridRow {
                                Button("Add dimension", systemImage: "plus") {
                                    let numCards = columns.map { $0.values.count }.max() ?? 0
                                    let newColumn = Column(name: "New Dimension", values: Array(repeating: "", count: numCards))
                                    columns.append(newColumn)
                                }
                            }
                        }
                        
                        Button("Add card", systemImage: "plus") {
                            for i in columns.indices {
                                columns[i].values.append("")
                            }
                        }
                    }
                }
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
