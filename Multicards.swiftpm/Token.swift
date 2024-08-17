import Foundation

func storeToken(token: String) {
    let tokenData = token.data(using: .utf8)!
    let query = [
        kSecClass: kSecClassGenericPassword,
        kSecAttrAccount: "authToken",
        kSecValueData: tokenData
    ] as [String : Any]
    
    SecItemAdd(query as CFDictionary, nil)
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
