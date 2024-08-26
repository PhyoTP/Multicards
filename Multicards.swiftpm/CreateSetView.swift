import SwiftUI

struct CreateSetView: View {
    @State var set: CardSet = CardSet(name: "", cards: [Card(sides: ["": ""])], creator: "", isPublic: false)
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var showSheet = false
    
    @State private var columns: [Column] = [Column(name: "", values: [""])]
    
    var userData: UserData
    
    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $set.name)
                if userData.isLoggedIn{
                    Toggle("Make Public", isOn: $set.isPublic)
                }
            }
            
            
                        
            Section("Table") {
                Button("Import", systemImage: "square.and.arrow.down")
                {
                    showSheet = true
                }
                ScrollView(.horizontal) {
                    HStack{
                        Grid{
                            ForEach($columns){$column in
                                GridRow{
                                    TextField("Dimension",text: $column.name)
                                        .bold()
                                        .padding(5)
                                        .background(colorScheme == .dark ? .black : Color(uiColor: .systemGray3))
                                        .cornerRadius(10)
                                    ForEach($column.values, id: \.self){$value in
                                        TextField("Value", text: $value)
                                            .padding(5)
                                            .background(Color(uiColor: .systemGray6))
                                            .cornerRadius(10)
                                    }
                                } 
                            }
                            GridRow{
                                Button("Add dimension",systemImage: "plus"){
                                    var numCards = 0
                                    for i in columns{
                                        if i.values.count>numCards{
                                            numCards = i.values.count
                                        }
                                    }
                                    var newColumn = Column(name: "New Dimension", values: [])
                                    for _ in 0..<numCards{
                                        newColumn.values.append("")
                                    }
                                    columns.append(newColumn)
                                }
                            }
                        }
                        Button("Add card",systemImage: "plus"){
                            for i in columns.indices{
                                columns[i].values.append("")
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
#Preview{
    CreateSetView(userData: UserData())
        .preferredColorScheme(.light)
}
