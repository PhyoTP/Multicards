import Foundation
import SwiftUI

class SetsManager: ObservableObject {
    @Published var sets: [SetCover]?
    
    
    
    func getSets() {
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets")!
        sets = nil
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: apiURL)
                
                
                try await MainActor.run {
                    self.sets = try JSONDecoder().decode([SetCover].self, from: data)
                }
            } catch {
                print("Failed to fetch sets: \(error.localizedDescription)")
            }
        }
    }
    func getSet(_ id: UUID) async throws -> CardSet {
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/set/" + id.uuidString)!
        
        do {
            let (data, _) = try await URLSession.shared.data(from: apiURL)
            return try JSONDecoder().decode(CardSet.self, from: data)
            
        } catch {
            print("Failed to fetch set: \(error.localizedDescription)")
            throw URLError(.badServerResponse)
        }
    }
    func postSet(_ set: CardSet) {
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets")!
        Task {
            do {
                var request = URLRequest(url: apiURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                // Encode the data
                let jsonData = try JSONEncoder().encode(set)
                request.httpBody = jsonData
                
                // Perform the network request
                let (_, response) = try await URLSession.shared.data(for: request)
                
                // Check if the response is an HTTPURLResponse
                if let httpResponse = response as? HTTPURLResponse {
                    // Check for the expected status code
                    if httpResponse.statusCode == 201 {
                        print("Successfully posted the set")
                    } else {
                        print("Unexpected status code: \(httpResponse.statusCode)")
                        throw URLError(.badServerResponse)
                    }
                } else {
                    throw URLError(.badServerResponse)
                }
            } catch {
                // Handle errors
                print("Failed to post set: \(error.localizedDescription)")
            }
        }
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
        
        
        
    }
    
    func sync() {
//        print("syncing")
        
        if let token = retrieveToken() {
//            print(token)
            
            guard let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/userdata/sets") else {
                print("Invalid URL")
                return
            }
            
            Task {
                do {
                    var request = URLRequest(url: apiURL)
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    
                    // Perform the network request
                    let (data, response) = try await URLSession.shared.data(for: request)
                    
                    // Validate response
                    if let httpResponse = response as? HTTPURLResponse{
                        print("Syncing HTTP Status code: \(httpResponse.statusCode)")
                        guard httpResponse.statusCode == 200 else {
                            throw URLError(.badServerResponse)
                        }
                    }
                    
                    // Decode and update sets on the main thread
                    try await MainActor.run {
                        if let responseString = String(data: data, encoding: .utf8) {
                            print("Syncing Response Body: \(responseString)")
                        }
                        let sets = try JSONDecoder().decode([CardSet].self, from: data)
//                        print(sets)
                        
                        // Add missing sets to localSets
                        let newSets = sets.filter { set in
                            !localSets.contains { $0.id == set.id }
                        }
                        localSets.append(contentsOf: newSets)
                    }
                    
                    // Update sets after localSets have been modified
                    updateSets()
                } catch {
                    print("Failed to sync sets: \(error.localizedDescription)")
                }
            }
        } else {
            print("Token retrieval failed")
        }
    }
    
    func updateSets() {
        if let token = retrieveToken(){
            guard let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/update/sets") else {
                print("Invalid URL")
                return
            }
            Task{
                do{
                    var request = URLRequest(url: apiURL)
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "PATCH"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    request.httpBody = try JSONEncoder().encode(["sets": localSets])
                    
                    let (_, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        throw URLError(.badServerResponse)
                    }
                }catch{
                    print("Failed to update sets: \(error.localizedDescription)")
                }
            }
        }
    }
    func updateSet(_ set: CardSet){
        if let token = retrieveToken(){
            guard let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets/update/"+set.id.uuidString) else {
                print("Invalid URL")
                return
            }
            Task{
                do{
                    var request = URLRequest(url: apiURL)
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "PUT"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    request.httpBody = try JSONEncoder().encode(set)
                    
                    let (_, response) = try await URLSession.shared.data(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        
                        throw URLError(.badServerResponse)
                    }
                }catch{
                    print("Failed to update set: \(error.localizedDescription)")
                }
            }
        }
    }
    func deleteSet(_ set: CardSet){
        if let token = retrieveToken(){
            guard let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets/delete/"+set.id.uuidString) else {
                print("Invalid URL")
                return
            }
            Task{
                do{
                    var request = URLRequest(url: apiURL)
                    request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
                    request.httpMethod = "DELETE"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    
                    
                    let (_, response) = try await URLSession.shared.data(for: request)
                    
                    if let httpResponse = response as? HTTPURLResponse{
                        print("Delete HTTP Status code: \(httpResponse.statusCode)")
                        guard httpResponse.statusCode == 204 else {
                            throw URLError(.badServerResponse)
                        }
                    }
                }catch{
                    print("Failed to delete set: \(error.localizedDescription)")
                }
            }
        }
    }
}

