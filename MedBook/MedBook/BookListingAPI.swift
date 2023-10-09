import Foundation
import UIKit

struct SearchResults: Codable {
    let docs: [Document]
}

struct Document: Codable {
    let key: String
    let title: String
    let author_name: [String]?
    let ratings_average: Double?
    let ratings_count: Int?
    let cover_i: Int?
}

struct Book: Codable {
    let title: String
    let first_publish_date: String?
    let description: String
    let value: String?
    
}

// Singleton class to handle API requests for book data
class BookListingAPI {
    // Singleton instance
    static let shared = BookListingAPI()
    
    
    // Function to fetch country data from the API
    func fetchSearchResults(searchText: String, limit: Int, completion: @escaping((SearchResults) -> Void)) {
        let url = "https://openlibrary.org/search.json?title=\(searchText)&limit=\(limit)"
        
        // Create a URL from the endpoint string
        guard let url = URL(string: url) else {
            return
        }

        // Create a URLSession for network requests
        let session = URLSession.shared
        
        // Create a data task to fetch data from the URL
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("#Book logs \(error)")
                return
            }
            
            // Ensure that data is available
            guard let data = data else {
                print("#Book logs No data received")
                return
            }
            
            do {
                // Parse the JSON data into an APIResponse object
                
                let result = try JSONDecoder().decode(SearchResults.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        
        // Start the data task
        task.resume()
    }
    
    func listBook(key: String, completion: @escaping((Book) -> Void)) {
        let url = "https://openlibrary.org/\(key).json"
        // Create a URL from the endpoint string
        guard let url = URL(string: url) else {
            return
        }
        
        // Create a URLSession for network requests
        let session = URLSession.shared
        
        // Create a data task to fetch data from the URL
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("#Book logs \(error)")
                return
            }
            
            // Ensure that data is available
            guard let data = data else {
                print("#Book logs No data received")
                return
            }
            
            do {
                // Parse the JSON data into an APIResponse object
                
                let result = try JSONDecoder().decode(Book.self, from: data)
                completion(result)
            } catch {
                print(error)
            }
        }
        
        // Start the data task
        task.resume()
    }
    
    func loadCoverImage(key: Int, completion: @escaping((Data) -> Void)) {
        let url = "https://covers.openlibrary.org/b/id/\(key).jpg"
        // Create a URL from the endpoint string
        guard let url = URL(string: url) else {
            return
        }
        
        // Create a URLSession for network requests
        let session = URLSession.shared
        
        // Create a data task to fetch data from the URL
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("#Book logs \(error)")
                return
            }
            
            // Ensure that data is available
            guard let data = data else {
                print("#Book logs No data received")
                return
            }
            completion(data)
        }
        
        // Start the data task
        task.resume()
    }
}
