import SwiftUI

struct EditSetView: View {
    @Binding var set: CardSet
    @Environment(\.dismiss) var dismiss
    @State private var columns: [Column] = [Column(name: "", values: [""]),Column(name: "", values: [""])]
    @EnvironmentObject var userData: UserData
    @State private var showAlert = false
    @State private var alertDesc = ""
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @State private var tagsText = ""
    var body: some View {
        Form {
            Section("Details") {
                TextField("Title", text: $set.name)
                HStack{
                    Text("Tags: ")
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack{
                            ForEach(set.safeTags, id: \.self){tag in
                                HStack{
                                    Text(tag)
                                    Button{
                                        set.tags!.removeAll(where: { $0 == tag})
                                    }label:{
                                        Image(systemName: "xmark")
                                    }
                                }
                                    .padding(5)
                                    .background(RoundedRectangle(cornerRadius: 10).fill(accent))
                                    .foregroundStyle(.black)
                                
                            }
                        }
                    }
                }
                HStack{
                    TextField("Add tag", text: $tagsText)
                    Button("Add"){
                        if set.tags == nil{
                            set.tags = []
                        }
                        set.tags!.append(tagsText)
                        tagsText = ""
                    }
                    .disabled(tagsText.isEmpty)
                }
            }
            .listRowBackground(back)
            Section("Table") {
                
                GridView(columns: $columns)
            }
            .listRowBackground(back)
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
            .listRowBackground(back)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertDesc), dismissButton: .default(Text("OK")))
        }
        .unifiedBackground()
    }
}


