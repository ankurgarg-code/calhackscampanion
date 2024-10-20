import Foundation

// The full response model
struct AlertResponse: Decodable {
    let total: String
    let data: [Alert] // Expect a single array of Alert objects, not a nested array
    let limit: String
    let start: String
}

// Alert model for individual alerts
struct Alert: Decodable, Identifiable {
    let category: String
    let description: String
    let id: String
    let parkCode: String
    let title: String
    let url: String
    let lastIndexedDate: String
    let relatedRoadEvents: [RoadEvent]?
}

// RoadEvent model for related road events (if any)
struct RoadEvent: Decodable {
    let title: String
    let id: String
    let type: String
    let url: String
}
