import Foundation

struct ParkResponse: Decodable {
    let data: [Park]
}

struct Park: Decodable, Identifiable, Equatable {
    let id: String
    let fullName: String
    let description: String
    let latLong: String
    let parkCode: String
    let activities: [Activity]  // Store park activities
    let entranceFees: [EntranceFee]  // Store entrance fees
    let directionsInfo: String  // Directions for visitors
    let weatherInfo: String  // Weather information for the park
    let operatingHours: [OperatingHours]  // Operating hours

    // Computed properties to parse latitude and longitude
    var latitude: Double? {
        return parseLatitudeLongitude().latitude
    }

    var longitude: Double? {
        return parseLatitudeLongitude().longitude
    }

    private func parseLatitudeLongitude() -> (latitude: Double?, longitude: Double?) {
        let components = latLong.split(separator: ",")
        let latComponent = components.first?.split(separator: ":").last?.trimmingCharacters(in: .whitespaces)
        let longComponent = components.last?.split(separator: ":").last?.trimmingCharacters(in: .whitespaces)

        if let latString = latComponent, let longString = longComponent,
           let lat = Double(latString), let lon = Double(longString) {
            return (lat, lon)
        }
        return (nil, nil)
    }
}

// Additional models for activities, entrance fees, and hours
struct Activity: Decodable, Equatable {
    let id: String
    let name: String
}

struct EntranceFee: Decodable, Equatable {
    let cost: Double
    let description: String
    let title: String
    
    // Custom decoding to handle both String and Double for the cost field
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            let costStringOrDouble = try container.decode(StringOrDouble.self, forKey: .cost)
            
            // Assign cost based on the parsed value
            self.cost = costStringOrDouble.value
            self.description = try container.decode(String.self, forKey: .description)
            self.title = try container.decode(String.self, forKey: .title)
        }

        enum CodingKeys: String, CodingKey {
            case cost, description, title
        }
}

struct OperatingHours: Decodable, Equatable {
    let name: String
    let description: String
    let standardHours: StandardHours
}

struct StandardHours: Decodable, Equatable {
    let sunday: String
    let monday: String
    let tuesday: String
    let wednesday: String
    let thursday: String
    let friday: String
    let saturday: String
}

// A helper enum to decode a String or Double for the 'cost' field
enum StringOrDouble: Decodable, Equatable {
    case string(String)
    case double(Double)

    var value: Double {
        switch self {
        case .string(let str):
            return Double(str) ?? 0.0
        case .double(let dbl):
            return dbl
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let doubleValue = try? container.decode(Double.self) {
            self = .double(doubleValue)
        } else if let stringValue = try? container.decode(String.self) {
            self = .string(stringValue)
        } else {
            throw DecodingError.typeMismatch(StringOrDouble.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Expected String or Double"))
        }
    }
}
