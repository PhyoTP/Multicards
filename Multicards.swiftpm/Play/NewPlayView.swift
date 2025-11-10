import SwiftUI

struct NewPlayView: View{
    @State private var gamemode = ""
    var cards: [Card]
    @State private var chosenSides: [String:String] = [:]
    @State private var chosenSettings: [String: String] = [:]
    var body: some View{
        NavigationStack{
            VStack{
                HStack{
                    Text("Choose a game mode").header()
                    Spacer()
                }
                HStack{
                    Text("aaaaaaaaaaaaaaaaa")
                }
                .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(bg)
        }
    }
}
#Preview{
    NewPlayView(cards: [])
        .preferredColorScheme(ColorScheme.dark)
    
}
