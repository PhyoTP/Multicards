import SwiftUI

struct GridView: View{
    @Binding var columns: [Column]
    var body: some View{
        ScrollView(.horizontal) {
            HStack {
                Grid {
                    GridRow{
                        Text("Dimension")
                            .fontWeight(.medium)
                            .offset(x:-30)
                        Spacer()
                        Rectangle()
                            .fill(Color(.systemGray3))
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
                                .fill(Color(.systemGray3))
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
}
