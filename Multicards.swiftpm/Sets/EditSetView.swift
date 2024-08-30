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
                
                ScrollView(.horizontal) {
                    HStack {
                        Grid {
                            GridRow{
                                Text("Dimension")
                                    .fontWeight(.medium)
                                    .offset(x:-30)
                                Spacer()
                                Rectangle()
                                    .fill(Color(uiColor: .systemGray3))
                                    .frame(width: 3)
                                ForEach(0..<numCards(columns), id: \.self){num in
                                    Button{
                                        for i in columns.indices{
                                            columns[i].values.remove(at: num)
                                        }
                                    }label: {
                                        Image(systemName: "minus.circle.fill")
                                            .foregroundStyle(.red)
                                    }
                                    Spacer()
                                }
                                Button("Add card", systemImage: "plus") {
                                    for i in columns.indices {
                                        columns[i].values.append("")
                                    }
                                }
                            }
                            ForEach($columns) { $column in
                                Divider()
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
                                        if index != column.values.count-1{
                                            HStack { Divider() }
                                        }
                                    }
                                }
                            }
                            
                            GridRow {
                                Button("Add dimension", systemImage: "plus") {
                                    let numCards = columns.map { $0.values.count }.max() ?? 0
                                    let newColumn = Column(name: "New Dimension", values: Array(repeating: "", count: numCards))
                                    columns.append(newColumn)
                                }
                            }
                        }
                        
                    }
                }
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
