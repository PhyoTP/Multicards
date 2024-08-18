import SwiftUI
class UserManager: ObservableObject {
    
    func login(_ user: User) async throws {
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/login")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["username": user.username, "password": user.password]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let token = json["access_token"] as? String {
            storeToken(token: token)
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
    func register(_ user: User) async throws {
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/register")!
        var request = URLRequest(url: apiURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let parameters: [String: Any] = ["username": user.username, "password": user.password]
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
           let token = json["access_token"] as? String {
            storeToken(token: token)
        } else {
            throw URLError(.cannotParseResponse)
        }
    }
}
