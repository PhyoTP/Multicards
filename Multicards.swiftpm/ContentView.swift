import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            LibraryView()
                .tabItem { 
                    Label("Library", systemImage: "rectangle.stack.fill")
                }
            HomeView()
                .tabItem { 
                    Label("Home", systemImage: "house.fill")
                }
        }
        .onAppear(){
            let card1 = Card(sides: ["front": "Question 1", "back": "Answer 1"])
            let card2 = Card(sides: ["front": "Question 2", "back": "Answer 2","meaning":"Here"])
            let exampleSet = Set(name: "Sample Set", cards: [card1, card2])
            
            do {
                let jsonData = try JSONEncoder().encode(exampleSet)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                }
            } catch {
                print("Error encoding JSON: \(error)")
            }
            print(exampleSet.keys)
        }
    }
}
