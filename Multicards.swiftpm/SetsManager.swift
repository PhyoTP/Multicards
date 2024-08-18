import Foundation
import SwiftUI

class SetsManager: ObservableObject {
    @Published var sets: [Set]?
    let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/multicards/sets")!
    func getSets() {
        sets = nil
        Task {
            let (data, _) = try await URLSession.shared.data(from: apiURL)
            print("Got the data!")
            print(String(data: data, encoding: .utf8)!)
            try await MainActor.run {
                self.sets = try JSONDecoder().decode([Set].self, from: data)
            }
        }
    }
    func postSet(_ set: Set) async throws {
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Encode the Set into JSON data
        let jsonData = try JSONEncoder().encode(set)
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // Check for HTTP errors
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        
        // Optionally decode the response data if needed
        print("Posted the data successfully!")
        print(String(data: data, encoding: .utf8)!)
    }
}

class LocalSetsManager: ObservableObject {
    @Published var localSets: [Set] = [] {
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
           let localSetsDecoded = try? propertyListDecoder.decode([Set].self, from: retrievedlocalSetsData) {
            localSets = localSetsDecoded
        }
    }
    
}
