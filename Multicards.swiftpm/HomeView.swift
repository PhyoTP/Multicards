import SwiftUI

struct HomeView: View{
    @StateObject var setsManager = SetsManager()
    var body: some View{
        NavigationStack{
            
                if let sets = setsManager.sets{
                    List(sets, id: \.self){ set in
                        Text(set.name)
                    }
                    .navigationTitle("Multicards")
                }else{
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            
        }
        .onAppear(){
            setsManager.getSets()
        }
    }
}
