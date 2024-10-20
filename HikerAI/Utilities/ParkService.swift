//
//  ParkService.swift
//  HikerAI
//
//  Created by Arnur Sabet on 19.10.2024.
//

import Foundation

class ParkService {
    let baseURL = "https://developer.nps.gov/api/v1/parks"
    let apiKey = "xyfILj61Ea5cAqVy5qc9BpWxBX8sia2A2nHkvPN7"  // Replace with your actual API key

    // Function to fetch parks based on latitude and longitude
    func fetchParks(latitude: Double, longitude: Double, completion: @escaping (Result<[Park], Error>) -> Void) {
        var urlComponents = URLComponents(string: baseURL)!
        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey),
            URLQueryItem(name: "limit", value: "20"),  // Limiting the number of parks returned
            URLQueryItem(name: "latitude", value: "\(latitude)"),
            URLQueryItem(name: "longitude", value: "\(longitude)")
        ]

        guard let url = urlComponents.url else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else { return }

            do {
                let parkResponse = try JSONDecoder().decode(ParkResponse.self, from: data)
                completion(.success(parkResponse.data))
            } catch {
                completion(.failure(error))
            }
        }

        task.resume()
    }
}
