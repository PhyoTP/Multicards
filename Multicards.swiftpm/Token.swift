import Foundation
import Security

func storeToken(token: String) {
    let tokenData = token.data(using: .utf8)!
    
    // Query to check if the token already exists
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: "authToken"
    ] as [String: Any]
    
    // Attributes to update if the token exists
    let attributesToUpdate = [
        kSecValueData: tokenData
    ] as [String: Any]
    
    // Try to update the existing token
    let status = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
    
    // If the token doesn't exist, add it
    if status == errSecItemNotFound {
        let addQuery = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: "authToken",
            kSecValueData: tokenData
        ] as [String: Any]
        
        SecItemAdd(addQuery as CFDictionary, nil)
    } else if status != errSecSuccess {
        // Handle other possible errors
        print("Failed to store token: \(status)")
    }
}
func retrieveToken() -> String? {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: "authToken",
        kSecReturnData: true,
        kSecMatchLimit: kSecMatchLimitOne
    ] as [String : Any]
    
    var dataTypeRef: AnyObject? = nil
    let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
    
    if status == errSecSuccess, let data = dataTypeRef as? Data {
        return String(data: data, encoding: .utf8)
    }
    return nil
}
func deleteToken() {
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: "authToken"
    ] as [String : Any]
    
    SecItemDelete(query as CFDictionary)
}
