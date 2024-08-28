import SwiftUI

struct CardSet: Codable, Identifiable{
    var id = UUID()
    var name: String
    var cards: [Card]
    var creator: String
    var isPublic: Bool
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
}
struct Card: Codable, Identifiable{
    var id = UUID()
    var sides: [String: String] 
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
    
    var columns: [Column] = [Column(name: "Term", values: []),Column(name: "Definition", values: [])]
    
    for card in rawCards {
        // Split each card into term and definition based on the term separator
        let components = card.components(separatedBy: termSeparator.rawValue)
        
        if components.count == 2 {
            columns[0].values.append(components[0].trimmingCharacters(in: .whitespacesAndNewlines))
            columns[1].values.append(components[1].trimmingCharacters(in: .whitespacesAndNewlines))
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


