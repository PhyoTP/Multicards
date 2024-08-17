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
class LocalSetsManager{
    
}
