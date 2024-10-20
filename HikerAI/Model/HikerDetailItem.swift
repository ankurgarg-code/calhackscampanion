import Foundation

// Conforming to Identifiable and Equatable
struct HikerDetailItem: Identifiable, Equatable {
    let id = UUID()  // Unique identifier
    let name: String  // The item name
}
