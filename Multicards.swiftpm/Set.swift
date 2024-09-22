import SwiftUI

struct CardSet: Codable, Identifiable{
    var id = UUID()
    var name: String
    var cards: [Card]
    var creator: String
    var isPublic: Bool
    func keys() -> [String]{
        var tempKey: [String] = []
        for i in cards{
            for j in i.sides.keys{
                if !tempKey.contains(j){
                    tempKey.append(j)
                }
            }
        }
        return tempKey
    }
    mutating func convertColumns(_ columns: [Column]){
        var tempCards: [Card] = []
        let names: [String] = columns.map{ $0.name }
        for _ in 0..<numCards(columns){
            tempCards.append(Card(sides: [:]))
        }
        for i in names{
            for j in tempCards.indices{
                tempCards[j].sides[i] = findColumn(columns, name: i).values[j]
            }
        }
        self.cards = tempCards
    }
    func convertToColumns() -> [Column] {
        var tempColumns: [Column] = []
        
        // Initialize columns with the keys
        for key in keys() {
            tempColumns.append(Column(name: key, values: []))
        }
        
        // Fill in the values for each column
        for card in self.cards {
            for (sideName, sideValue) in card.sides {
                // Find the corresponding column by name and append the value
                if let columnIndex = tempColumns.firstIndex(where: { $0.name == sideName }) {
                    tempColumns[columnIndex].values.append(sideValue)
                }
            }
        }
        
        return tempColumns
    }
}
struct Card: Codable, Identifiable, Hashable{
    var id = UUID()
    var sides: [String: String] 
    var newSides: [Side]{
        var tempSides: [Side] = []
        for (i, j) in sides{
            tempSides.append(Side(cardID: id, title: i, value: j))
        }
        return tempSides
    }
}
struct Side: Identifiable, Hashable{
    var id = UUID()
    var cardID: UUID
    var title: String
    var value: String
    var color: UIColor = .systemGray4
    var opacity = 1
}
struct Column: Identifiable, Equatable{
    var id = UUID()
    var name: String
    var values: [String]
}
struct User: Codable{
    var username: String
    var password: String
}
enum TermSeparator: String, CaseIterable {
    case tab = "\t"
    case comma = ","
}

enum CardSeparator: String, CaseIterable {
    case newline = "\n"
    case semicolon = ";"
}

func convertStringToColumns(input: String, termSeparator: TermSeparator, cardSeparator: CardSeparator) -> [Column] {
    // Split the string into cards based on the card separator
    let rawCards = input.components(separatedBy: cardSeparator.rawValue)
    
    var columns: [Column] = []
    var columnCount = 0
    
    for card in rawCards {
        // Split each card into terms based on the term separator
        let components = card.components(separatedBy: termSeparator.rawValue).map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
        
        // Ensure the columns array has enough columns to accommodate all components
        if components.count > columnCount {
            for i in columnCount..<components.count {
                columns.append(Column(name: "Dimension \(i + 1)", values: []))
            }
            columnCount = components.count
        }
        
        // Append each component to the corresponding column
        for i in components.indices {
            columns[i].values.append(components[i])
        }
    }
    
    return columns
}


func findColumn(_ columns: [Column], name: String)->Column{
    for i in columns{
        if i.name==name{
            return i
        }
    }
    return Column(name: "", values: [])
}
func numCards(_ columns: [Column])->Int{
    var tempCards = 0
    for i in columns{
        if i.values.count>tempCards{
            tempCards = i.values.count
        }
    }
    return tempCards
}

func convertToCards(_ columns: [Column])->[Card]{
    var tempCards: [Card] = []
    let names: [String] = columns.map{ $0.name }
    for _ in 0..<numCards(columns){
        tempCards.append(Card(sides: [:]))
    }
    for i in names{
        for j in tempCards.indices{
            tempCards[j].sides[i] = findColumn(columns, name: i).values[j]
        }
    }
    return tempCards
}
func combineColumns(_ columns: [Column])->Column{
    var tempColumn = Column(name: "", values: [])
    for i in columns{
        if tempColumn.name.isEmpty{
            tempColumn.name += i.name
        }else{
            tempColumn.name += ", " + i.name
        }
    }
    for i in columns{
        if i == columns[0]{
            tempColumn.values = i.values
        }else{
            for j in i.values.indices{
                tempColumn.values[j] += ", " + i.values[j]
            }
        }
    }
    return tempColumn
}
func prepareCards(questions: [Column], answers: [Column])->[Card]{
    let questionColumn = combineColumns(questions)
    let answerColumn = combineColumns(answers)
    return convertToCards([questionColumn, answerColumn])
}
 
struct SetCover: Identifiable, Codable{
    var id: UUID
    var name: String
    var creator: String
}
