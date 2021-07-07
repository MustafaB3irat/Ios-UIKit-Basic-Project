
import Foundation

enum UserError: Error {
    case noAvailableUsers, invalidRequest
}

class UsersRequest {
    
    var apiURL: URL
    private let RESOURCE_URL = APIs.usersURL
    
    init() {
        guard let apiURL = URL(string: RESOURCE_URL) else {fatalError()}
        self.apiURL = apiURL
    }
    
    func getUsers(completion: @escaping (Result<[User], UserError>) -> Void) {
        let dataTask = URLSession.shared.dataTask(with: apiURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noAvailableUsers))
                return
            }
            do {
                let response = try (JSONDecoder()).decode([User].self, from: jsonData)
                completion(.success(response))
                
            } catch {
                completion(.failure(.invalidRequest))
            }
        }
        dataTask.resume()
    }
}
