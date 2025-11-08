import SwiftUI

struct HomeView: View{
    @EnvironmentObject var setsManager: SetsManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @EnvironmentObject var userData: UserData
    @State private var input = ""
    var filteredSets: [SetCover]{
        if let sets = setsManager.sets{
            if input.isEmpty{
                return Array(Set(sets).subtracting(Set(recentSetManager.sets)))
            }else{
                return sets.filter{$0.name.lowercased().contains(input.lowercased())}
            }
        }else{
            return []
        }
    }
    var filteredRecentSets: [SetCover]{
        if input.isEmpty{
            return recentSetManager.sets.reversed()
        }else{
            return recentSetManager.sets.filter{$0.name.lowercased().contains(input.lowercased())}
        }
    }
    @Environment(RecentSetManager.self) var recentSetManager
    var body: some View{
        @Bindable var recentSetManager = recentSetManager
        NavigationStack{
            Form{
                if !recentSetManager.sets.isEmpty{
                    Section{
                        List(filteredRecentSets){recentSet in
                            RedirectSetView(set:recentSet)
                        }
                    }header: {
                        HStack{
                            Text("Recent")
                            Spacer()
                            Button("Clear"){
                                recentSetManager.sets = []
                            }
                            .font(.caption)
                        }
                    }
                }
                Section("Discover"){
                    if (setsManager.sets != nil){
                        List(filteredSets) { set in
                            RedirectSetView(set: set)
                        }
                        
                        
                        
                        
                    }else{
                        ProgressView()
                            .onAppear(){
                                setsManager.getSets()
                                
                            }
                        
                    }
                }
            }
            .navigationTitle(userData.isLoggedIn ? "Hello, " + userData.name : "Multicards")
        }
        .searchable(text: $input)
        .refreshable{
            setsManager.sets = []
            setsManager.getSets()
        }
    }
}
struct RedirectSetView: View{
    var set: SetCover
    @EnvironmentObject var setsManager: SetsManager
    @EnvironmentObject var localSetsManager: LocalSetsManager
    @EnvironmentObject var userData: UserData
    @Environment(RecentSetManager.self) var recentSetManager
    var body: some View{
        @Bindable var recentSetManager = recentSetManager
        NavigationLink(destination: {
            if set.creator == userData.name {
                if let localSetIndex = localSetsManager.localSets.firstIndex(where: { $0.id == set.id }) {
                    LocalSetView(set: $localSetsManager.localSets[localSetIndex])
                        .environmentObject(localSetsManager)
                        .environmentObject(setsManager)
                        .onAppear(){
                            if recentSetManager.sets.contains(where: {$0.id==set.id}){
                                recentSetManager.sets.removeAll(where: {$0.id==set.id})
                            }
                            recentSetManager.sets.append(set)
                            print(recentSetManager.sets.map{$0.name})
                        }
                } else {
                    Text("Set not found locally")
                        .onAppear(){
                            Task{
                                try await localSetsManager.localSets.append(setsManager.getSet(set.id))
                            }
                            localSetsManager.sync()
                        }
                }
            } else {
                SetView(setID: set.id)
                    .environmentObject(localSetsManager)
                    .environmentObject(setsManager)
                    .onAppear(){
                        if recentSetManager.sets.contains(where: {$0.id==set.id}){
                            recentSetManager.sets.removeAll(where: {$0.id==set.id})
                        }
                        recentSetManager.sets.append(set)
                        print(recentSetManager.sets.map{$0.name})
                    }
            }
        }) {
            HStack{
                VStack(alignment: .leading){
                    Text(set.name)
                        .font(.custom("AvenirNext-bold", size: 18))
                    HStack{
                        Text("By "+set.formattedCreator)
                            .font(.caption)
                        Spacer()
                        Text(String(set.cardCount)+" terms")
                            .font(.caption)
                        Spacer()
                    }
                }
                if set.creator == userData.name{
                    Image(systemName: "person.circle.fill")
                        .padding()
                        .foregroundStyle(accent)
                }else if (localSetsManager.localSets.map{$0.id}.contains(set.id)){
                    Image(systemName: "star.fill")
                        .padding()
                        .foregroundStyle(accent)
                }
            }
            .foregroundStyle(accent)
        }
        .buttonStyle(.plain)
    }
}
