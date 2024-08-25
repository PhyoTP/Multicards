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
}
struct Card: Codable, Identifiable{
    var id = UUID()
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
    
    return CardSet(name: title, cards: cards, creator: creator, isPublic: false)
}

