import CryptoKit
import Foundation

// Enum to represent authentication errors
enum AuthError: Error {
    case usernameTaken
    case invalidPassword
    case invalidUsername
    case unknown
}

// Struct to represent authentication information (token)
struct AuthInfo: Codable {
    let token: String
}

// Singleton class for handling authentication
class Authentication {
    typealias AuthenticationHandler = (Result<String?, AuthError>) -> Void
    
    // Singleton instance
    static let shared = Authentication()
    
    // Key used for storing user data in Keychain
    private static let usersKey = "Users"
    
    private init() {}
    
    // Create a unique key for a user based on username, password, and salt
    private func makeKey(username: String, password: String) -> String {
        let salt = "ixs^X9T@12QQvu1W"
        return "\(username).\(password).\(salt)".sha256()
    }
    
    func signIn(username: String, password: String, completion: @escaping AuthenticationHandler) {
        // Check if the user exists in Keychain
        guard let usersData = KeychainWrapper.standard.data(forKey: Self.usersKey),
              let users = try? JSONDecoder().decode([String].self, from: usersData),
              users.contains(username) else {
            completion(.failure(.invalidUsername))
            return
        }
        let key = makeKey(username: username, password: password)
        
        // Check if the user's data exists in Keychain
        guard let data = KeychainWrapper.standard.data(forKey: key) else {
            completion(.failure(.invalidPassword))
            return
        }
        
        // Decode and retrieve the user's authentication information
        let authInfo = try! JSONDecoder().decode(AuthInfo.self, from: data)
        completion(.success(authInfo.token))
    }
    
    func signUp(username: String, password: String, completion: @escaping AuthenticationHandler) {
        // Retrieve the list of existing users from Keychain
        var users: [String] = []
        if let usersData = KeychainWrapper.standard.data(forKey: Self.usersKey) {
            let decodeUsers = try! JSONDecoder().decode([String].self, from: usersData)
            users.append(contentsOf: decodeUsers)
        }
        
        // Check if the username is already taken
        guard !users.contains(username) else {
            completion(.failure(.usernameTaken))
            return
        }
        // Generate a new authentication token
        let authInfo = AuthInfo(token: UUID().uuidString)
        let data = try! JSONEncoder().encode(authInfo)
        let key = makeKey(username: username, password: password)
        
        // Store the user's data in Keychain
        guard KeychainWrapper.standard.set(data, forKey: key) else {
            completion(.failure(.unknown))
            return
        }
        users.append(username)
        
        // Store the updated list of users in Keychain
        KeychainWrapper.standard.set(try! JSONEncoder().encode(users), forKey: Self.usersKey)
        completion(.success(nil))
    }
}

// Extension to compute SHA256 hash of a string
extension String {
    fileprivate func sha256() -> String {
        return SHA256.hash(data: Data(self.utf8)).description
    }
}
