import SwiftUI
class UserManager: ObservableObject {
    @Published var user = User(username: "", password: "") {
        didSet {
            save()
        }
    }
    
    init() {
        load()
    }
    
    func getArchiveURL() -> URL {
        let plistName = "user.plist"
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        return documentsDirectory.appendingPathComponent(plistName)
    }
    
    func save() {
        let archiveURL = getArchiveURL()
        let propertyListEncoder = PropertyListEncoder()
        let encodedUser = try? propertyListEncoder.encode(user)
        try? encodedUser?.write(to: archiveURL, options: .noFileProtection)
    }
    
    func load() {
        let archiveURL = getArchiveURL()
        let propertyListDecoder = PropertyListDecoder()
        
        if let retrievedUserData = try? Data(contentsOf: archiveURL),
           let userDecoded = try? propertyListDecoder.decode(User.self, from: retrievedUserData) {
            user = userDecoded
        }
    }
    func login() throws{
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/login")!
        Task{
            
                var request = URLRequest(url: apiURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let parameters: [String: Any] = ["username": user.username, "password": user.password]
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                try await MainActor.run(){
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["access_token"] as? String {
                        storeToken(token: token)
                    } else {
                        throw URLError(.cannotParseResponse)
                    }
                }
            
        }
    }
    func register() throws{
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/register")!
        Task{
            
                var request = URLRequest(url: apiURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let parameters: [String: Any] = ["username": user.username, "password": user.password]
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 201 else {
                    throw URLError(.badServerResponse)
                }
                try await MainActor.run(){
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["access_token"] as? String {
                        storeToken(token: token)
                    } else {
                        throw URLError(.cannotParseResponse)
                    }
                }
            
        }
    }
    func relogin(){
        let apiURL = URL(string: "https://phyotp.pythonanywhere.com/api/phyoid/login")!
        Task{
            do{
                var request = URLRequest(url: apiURL)
                request.httpMethod = "POST"
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                let parameters: [String: Any] = ["username": user.username, "password": user.password]
                request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
                
                let (data, response) = try await URLSession.shared.data(for: request)
                
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    throw URLError(.badServerResponse)
                }
                try await MainActor.run(){
                    if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any],
                       let token = json["access_token"] as? String {
                        storeToken(token: token)
                    } else {
                        throw URLError(.cannotParseResponse)
                    }
                }
            }catch{
                print("Failed to login: \(error.localizedDescription)")
            }
        }
    }
}
