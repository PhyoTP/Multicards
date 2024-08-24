import SwiftUI

struct CardSet: Codable, Hashable{
    var setID = UUID()
    var name: String
    var cards: [Card]
    func keys() -> Set<String>{
        var tempKey = Set<String>()
        for i in cards{
            for j in i.sides.keys{
                tempKey.insert(j)
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

func convertStringToSet(input: String, termSeparator: TermSeparator, cardSeparator: CardSeparator, title: String, creator: String) -> CardSet {
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
    
    return CardSet(setID: UUID(), name: title, cards: cards, creator: creator)
}
