import Foundation
import SwiftUI

class SetsManager: ObservableObject {
    @Published var sets: [CardSet]?
    
    let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets")!
    
    func getSets() {
        sets = nil
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: apiURL)
                print("Got the data!")
                print(String(data: data, encoding: .utf8)!)
                
                try await MainActor.run {
                    self.sets = try JSONDecoder().decode([CardSet].self, from: data)
                }
            } catch {
                print("Failed to fetch sets: \(error)")
            }
        }
    }
    
    func postSet(_ set: CardSet) async throws {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let jsonData = try JSONEncoder().encode(set)
        request.httpBody = jsonData
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
            throw URLError(.badServerResponse)
        }
        
        print("Posted the data successfully!")
    }
}

class LocalSetsManager: ObservableObject {
    @Published var localSets: [CardSet] = [] {
        didSet { 
            save() 
        }
    }
    
    init() {
        load() 
    }
    
    func getArchiveURL() -> URL {
        let plistName = "localSets.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedlocalSets = try? propertyListEncoder.encode(localSets)
        try? encodedlocalSets?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        if let retrievedlocalSetsData = try? Data(contentsOf: archiveURL),
           let localSetsDecoded = try? propertyListDecoder.decode([CardSet].self, from: retrievedlocalSetsData) {
            localSets = localSetsDecoded
        }
        Task{
            try await sync()
        }
    }
    
    func sync() async throws {
        if let token = retrieveToken(){
            let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/userdata")!
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            try await MainActor.run {
                let sets = try JSONDecoder().decode([CardSet].self, from: data)
                print(sets)
                for i in sets {
                    if !localSets.contains(where: { $0.id == i.id }) {
                        localSets.append(i)
                    }
                }
            }
            do{
                try await updateSets()
            }catch{
                
            }
            print(localSets)
        }
    }
    
    func updateSets() async throws {
        if let token = retrieveToken(){
            let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/update/sets")!
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "PATCH"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONEncoder().encode(["sets": localSets])
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
        }
    }
    func updateSet(_ set: CardSet) async throws{
        if let token = retrieveToken(){
            let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets/update/"+set.id.uuidString)!
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            request.httpBody = try JSONEncoder().encode(set)
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
        }
    }
    func deleteSet(_ set: CardSet) async throws{
        if let token = retrieveToken(){
            let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets/delete/"+set.id.uuidString)!
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "DELETE"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
            
            let (_, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
                throw URLError(.badServerResponse)
            }
        }
    }
}

