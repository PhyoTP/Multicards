import SwiftUI

struct CardSet: Codable, Identifiable{
    var id = UUID()
    var name: String
    var cards: [Card]
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
    func table()->[String:[String]]{
        var returnTable: [String:[String]]=[:]
        for i in keys(){
            returnTable[i]=[]
            for j in cards{
                if let thing = j.sides[i]{
                    returnTable[i]?.append(thing)
                }else{
                    returnTable[i]?.append("")
                }
            }
        }
        return returnTable
    }
    var creator: String
    var isPublic: Bool
    mutating func convertColumns(_ columns: [Column]){
        var tempCards: [Card] = []
        var names: [String] = []
        var numCards = 0
        for i in columns{
            names.append(i.name)
            if i.values.count>numCards{
                numCards = i.values.count
            }
        }
        for _ in 0..<numCards{
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
struct Column: Identifiable{
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
