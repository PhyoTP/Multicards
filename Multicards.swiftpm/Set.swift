import SwiftUI

struct Set: Codable{
    var name: String
    var cards: [Card]
    var keys: [String]{
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
}
struct Card: Codable{
    var sides: [String: String] 
}

