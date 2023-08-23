import Foundation

struct Feature: Codable {
    let attributes: Attributes
    let geometry: Geometry
}

struct Attributes: Codable {
    let OBJECTID: Int
    let University_Chapter: String
    let City: String
    let State: String
    let ChapterID: String?
    let MEVR_RD: String
}

struct Geometry: Codable {
    let x: Double
    let y: Double
}

struct APIResponse: Codable {
    let features: [Feature]
}

class ArcGIS_API {
    static let shared = ArcGIS_API()
    
    let url = "https://services2.arcgis.com/5I7u4SJE1vUr79JC/arcgis/rest/services/UniversityChapters_Public/FeatureServer/0/query?where=1%3D1&outFields=*&outSR=4326&f=json"
    
    func fetchLocationData(_ completion :@escaping((APIResponse) -> Void)) {
        print("#ArcGIS_API logs : API called")
        guard let url = URL(string: url) else {
            print("#ArcGIS_API logs : Invalid API URL")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("#ArcGIS_API logs : Error: \(error)")
                return
            }
            
            guard let data = data else {
                print("#ArcGIS_API logs : No data received")
                return
            }
            
            print("#ArcGIS_API logs : Data received")
            
            do {
                // Decode the JSON response into an array of Location objects
                let decoder = JSONDecoder()
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                completion(apiResponse)
                
            } catch {
                print("#ArcGIS_API logs : Error decoding JSON: \(error)")
            }
        }
        
        task.resume()
    }
}
