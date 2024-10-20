import Foundation

class AlertService {
    let baseURL = "https://developer.nps.gov/api/v1/alerts"
    
    // Function to fetch alerts based on the park code or state code
    func fetchAlerts(parkCode: String?, stateCode: String?, completion: @escaping (Result<[Alert], Error>) -> Void) {
        // Construct query parameters
        var queryItems = [URLQueryItem]()
        
        if let parkCode = parkCode {
            queryItems.append(URLQueryItem(name: "parkCode", value: parkCode))
        }
        
        if let stateCode = stateCode {
            queryItems.append(URLQueryItem(name: "stateCode", value: stateCode))
        }

        // Add limit parameter for limiting the number of results
        queryItems.append(URLQueryItem(name: "limit", value: "100"))
        queryItems.append(URLQueryItem(name: "api_key", value: "xyfILj61Ea5cAqVy5qc9BpWxBX8sia2A2nHkvPN7"))
        
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else { return }
        
        // Perform the network request
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let alertResponse = try JSONDecoder().decode(AlertResponse.self, from: data)
                completion(.success(alertResponse.data)) // Return the array of alerts
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
