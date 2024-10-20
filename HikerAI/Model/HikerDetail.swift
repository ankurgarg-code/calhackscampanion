//
//  HikerDetail.swift
//  HikerAI
//
//  Created by Arnur Sabet on 19.10.2024.
//

import Foundation

struct HikerDetail {
    var city: String
    var items: [HikerDetailItem]
    
    // You can add more fields as needed, such as:
    // var hikeDate: Date
    // var emergencyContacts: [String]
    
    // You can also add convenience methods for managing items, etc.
    mutating func addItem(_ item: HikerDetailItem) {
        items.append(item)
    }
    
    mutating func removeItem(_ item: HikerDetailItem) {
        if let index = items.firstIndex(of: item) {
            items.remove(at: index)
        }
    }
}
