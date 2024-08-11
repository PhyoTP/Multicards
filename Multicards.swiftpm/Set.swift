import SwiftUI

struct Set: Codable, Hashable{
    var setID: Int
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
    var creator: String = "Default iOS"
}
struct Card: Codable, Hashable{
    var sides: [String: String] 
}

