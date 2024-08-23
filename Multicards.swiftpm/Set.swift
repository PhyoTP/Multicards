import SwiftUI

struct Set: Codable, Hashable{
    var setID = UUID()
    var name: String
    var cards: [Card]
    func keys() -> [String]{
        var tempKey: [String] = []
        for i in cards{
            for j in i.sides.keys{
                if !(tempKey.contains(j)){
                    tempKey.append(j)
                }
            }
        }
        return tempKey
    }
    var creator: String
}
struct Card: Codable, Hashable{
    var sides: [String: String] 
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

func convertStringToSet(input: String, termSeparator: TermSeparator, cardSeparator: CardSeparator, title: String, creator: String) -> Set {
    // Split the string into cards based on the card separator
    let rawCards = input.components(separatedBy: cardSeparator.rawValue)
    
    var cards: [Card] = []
    
    for card in rawCards {
        // Split each card into term and definition based on the term separator
        let components = card.components(separatedBy: termSeparator.rawValue)
        
        if components.count == 2 {
            let newCard = Card(sides: ["term":components[0].trimmingCharacters(in: .whitespacesAndNewlines),"definition":components[1].trimmingCharacters(in: .whitespacesAndNewlines)])
            cards.append(newCard)
        }
    }
    
    return Set(name: title, cards: cards, creator: creator)
}
