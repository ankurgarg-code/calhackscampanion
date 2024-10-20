import SwiftUI
import CoreLocation
import MapKit
import Foundation

class HikeViewModel: NSObject, ObservableObject, MKLocalSearchCompleterDelegate {
    @Published var hikerDetails = HikerDetail(city: "", items: [])
    @Published var parks: [Park] = []  // Store fetched parks
    @Published var selectedPark: Park?  // Store the selected park
    @Published var alerts: [Alert] = [] // Store alerts for the selected park
    @Published var locationSuggestions: [MKLocalSearchCompletion] = [] // Store location suggestions
    @Published var hikeStarted = false  // Track hike status

    private var searchCompleter = MKLocalSearchCompleter()
    private let parkService = ParkService()
    private let alertService = AlertService()

    override init() {
        super.init()
        searchCompleter.delegate = self
    }

    // Fetch hike info based on some criteria (e.g., park, trails)
    func fetchHikeInfo(for parkCode: String) {
        let endpoint = "https://developer.nps.gov/api/v1/parks?parkCode=\(parkCode)&limit=1&api_key=xyfILj61Ea5cAqVy5qc9BpWxBX8sia2A2nHkvPN7"
        guard let url = URL(string: endpoint) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching hike info: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let parkResponse = try JSONDecoder().decode(ParkResponse.self, from: data)

                if let park = parkResponse.data.first {
                    DispatchQueue.main.async {
                        self.selectedPark = park  // Set the selected park
                    }
                }
            } catch {
                print("Error decoding park data: \(error)")
            }
        }.resume()
    }

    // Update search query for city suggestions
    func updateSearchQuery(_ query: String) {
        searchCompleter.queryFragment = query
    }

    // Delegate method that updates the list of suggestions
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        DispatchQueue.main.async {
            self.locationSuggestions = completer.results
        }
    }

    // Reverse geocode a location to get the city name
    func reverseGeocode(location: CLLocation, completion: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            if let placemark = placemarks?.first {
                let cityName = placemark.locality ?? "Unknown city"
                completion(cityName)
            } else {
                print("Error in reverse geocoding: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
    }

    func addItem(_ itemName: String) {
        let newItem = HikerDetailItem(name: itemName)
        hikerDetails.addItem(newItem)
    }

    // Remove an item from the hiker's list
    func removeItem(_ item: HikerDetailItem) {
        hikerDetails.removeItem(item)
    }

    // Function to select a park
    func selectPark(_ park: Park) {
        self.selectedPark = park
    }

    // Fetch nearby parks based on user's latitude and longitude
    func fetchNearbyParks(latitude: Double, longitude: Double) {
        let endpoint = "https://developer.nps.gov/api/v1/parks?limit=2000&start=0&api_key=xyfILj61Ea5cAqVy5qc9BpWxBX8sia2A2nHkvPN7"
        guard let url = URL(string: endpoint) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching parks: \(error)")
                return
            }

            guard let data = data else { return }

            do {
                let parkResponse = try JSONDecoder().decode(ParkResponse.self, from: data)
                let filteredParks = parkResponse.data.filter { park in
                    guard let parkLatitude = park.latitude, let parkLongitude = park.longitude else { return false }
                    let distance = self.calculateDistance(latitude1: latitude, longitude1: longitude, latitude2: parkLatitude, longitude2: parkLongitude)
                    return distance <= 100 // Only include parks within 100 miles
                }

                DispatchQueue.main.async {
                    self.parks = filteredParks
                }
            } catch {
                print("Error decoding park data: \(error)")
            }
        }.resume()
    }

    // Haversine formula to calculate the distance between two coordinates
    func calculateDistance(latitude1: Double, longitude1: Double, latitude2: Double, longitude2: Double) -> Double {
        let radius: Double = 3958.8 // Earth's radius in miles

        let lat1 = latitude1 * .pi / 180
        let lon1 = longitude1 * .pi / 180
        let lat2 = latitude2 * .pi / 180
        let lon2 = longitude2 * .pi / 180

        let deltaLat = lat2 - lat1
        let deltaLon = lon2 - lon1

        let a = sin(deltaLat / 2) * sin(deltaLat / 2) + cos(lat1) * cos(lat2) * sin(deltaLon / 2) * sin(deltaLon / 2)
        let c = 2 * atan2(sqrt(a), sqrt(1 - a))

        return radius * c
    }

    // Fetch alerts for the selected park
    func fetchAlertsForSelectedPark() {
        guard let park = selectedPark else { return }

        alertService.fetchAlerts(parkCode: park.parkCode, stateCode: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let alerts):
                    self.alerts = alerts
                case .failure(let error):
                    print("Failed to fetch alerts: \(error)")
                }
            }
        }
    }
}
