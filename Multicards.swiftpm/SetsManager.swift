import Foundation
import SwiftUI

class SetsManager: ObservableObject {
    @Published var sets: [Set]?
    
    let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets")!
    
    func getSets() {
        sets = nil
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: apiURL)
                print("Got the data!")
                print(String(data: data, encoding: .utf8)!)
                
                try await MainActor.run {
                    self.sets = try JSONDecoder().decode([Set].self, from: data)
                }
            } catch {
                print("Failed to fetch sets: \(error)")
            }
        }
    }
    
    func postSet(_ set: Set) async throws {
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
    @Published var localSets: [Set] = [] {
        didSet { save() }
    }
    
    init() { load() }
    
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
           let localSetsDecoded = try? propertyListDecoder.decode([Set].self, from: retrievedlocalSetsData) {
            localSets = localSetsDecoded
        }
    }
    
    func sync() async throws {
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/userdata")!
        var request = URLRequest(url: apiURL)
        request.setValue("Bearer \(retrieveToken())", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        try await MainActor.run {
            let sets = try JSONDecoder().decode([Set].self, from: data)
            print(sets)
            for i in sets {
                if !localSets.contains(where: { $0.setID == i.setID }) {
                    localSets.append(i)
                }
            }
        }
        try? await addSet()
        print(localSets)
    }
    
    func addSet() async throws {
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/update/sets")!
        var request = URLRequest(url: apiURL)
        request.setValue("Bearer \(retrieveToken())", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(["sets": localSets])
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    func updateSet(_ set: Set) async throws{
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets/update/"+set.setID.uuidString)!
        var request = URLRequest(url: apiURL)
        request.setValue("Bearer \(retrieveToken())", forHTTPHeaderField: "Authorization")
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(set)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
    }
    func deleteSet(_ set: Set) async throws{
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets/delete/"+set.setID.uuidString)!
        var request = URLRequest(url: apiURL)
        request.setValue("Bearer \(retrieveToken())", forHTTPHeaderField: "Authorization")
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 204 else {
            throw URLError(.badServerResponse)
        }
    }
}
