import SwiftUI

struct NewPlayView: View{
    @State private var gamemode = ""
    var cards: [Card]
    @State private var chosenSides: [String:String] = [:]
    @State private var chosenSettings: [String: String] = [:]
    var body: some View{
        NavigationStack{
            VStack{
                TabView(selection: $gamemode){
                    
                }
                .tabViewStyle(.page)
                Button("Next"){
                    
                }.big()
            }
            .padding()
        }
    }
}
#Preview{
    NewPlayView(cards: [])
        .tint(accent)
}
