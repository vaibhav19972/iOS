import CryptoKit
import Foundation

enum AuthError: Error {
    case usernameTaken
    case invalidPassword
    case invalidUsername
    case unknown
}

struct AuthInfo: Codable {
    let token: String
}

class Authentication {
    typealias AuthenticationHandler = (Result<String?, AuthError>) -> Void

    static let shared = Authentication()

    private static let usersKey = "Users"

    private init() {}

    private func makeKey(username: String, password: String) -> String {
        let salt = "ixs^X9T@12QQvu1W"
        return "\(username).\(password).\(salt)".sha256()
    }

    func signIn(username: String, password: String, completion: @escaping AuthenticationHandler) {
        guard let usersData = KeychainWrapper.standard.data(forKey: Self.usersKey),
              let users = try? JSONDecoder().decode([String].self, from: usersData),
              users.contains(username) else {
            completion(.failure(.invalidUsername))
            return
        }
        let key = makeKey(username: username, password: password)
        guard let data = KeychainWrapper.standard.data(forKey: key) else {
            completion(.failure(.invalidPassword))
            return
        }
        let authInfo = try! JSONDecoder().decode(AuthInfo.self, from: data)
        completion(.success(authInfo.token))
    }

    func signUp(username: String, password: String, completion: @escaping AuthenticationHandler) {
        var users: [String] = []
        if let usersData = KeychainWrapper.standard.data(forKey: Self.usersKey) {
            let decodeUsers = try! JSONDecoder().decode([String].self, from: usersData)
            users.append(contentsOf: decodeUsers)
        }
        guard !users.contains(username) else {
            completion(.failure(.usernameTaken))
            return
        }
        let authInfo = AuthInfo(token: UUID().uuidString)
        let data = try! JSONEncoder().encode(authInfo)
        let key = makeKey(username: username, password: password)
        guard KeychainWrapper.standard.set(data, forKey: key) else {
            completion(.failure(.unknown))
            return
        }
        users.append(username)
        KeychainWrapper.standard.set(try! JSONEncoder().encode(users), forKey: Self.usersKey)
        completion(.success(nil))
    }
}

extension String {
    fileprivate func sha256() -> String {
        return SHA256.hash(data: Data(self.utf8)).description
    }
}
