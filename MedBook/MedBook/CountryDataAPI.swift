import Foundation

// Struct to represent the data for an individual country
struct CountryData: Codable {
    let country: String
    let region: String
}

// Struct to represent the entire response from the API
struct APIResponse: Codable {
    let status: String
    let version: String
    let access: String
    let data: [String: CountryData]
}

// Singleton class to handle API requests for country data
class CountryDataAPI {
    // Singleton instance
    static let shared = CountryDataAPI()

    // API endpoint URL
    let url = "https://api.first.org/data/v1/countries"
    
    // Function to fetch country data from the API
    func fetchCountryData(_ completion: @escaping((APIResponse) -> Void)) {
        // Create a URL from the endpoint string
        guard let url = URL(string: url) else {
            return
        }
        
        // Create a URLSession for network requests
        let session = URLSession.shared
        
        // Create a data task to fetch data from the URL
        let task = session.dataTask(with: url) { data, response, error in
            if let error = error {
                print("#API logs \(error)")
                return
            }
            
            // Ensure that data is available
            guard let data = data else {
                print("#API logs No data received")
                return
            }
            
            do {
                // Parse the JSON data into an APIResponse object
                let result = try JSONDecoder().decode(APIResponse.self, from: data)
                completion(result)
            } catch {
                print("#API logs Error while decoding JSON data")
            }
        }
        // Start the data task
        task.resume()
    }
}
