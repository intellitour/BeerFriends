//
//  AbusiveContent.swift
//  BeerFriends
//
//  Created by Wesley Marra on 26/01/22.
//

import Foundation

struct AbusiveContent: Identifiable, Codable {
    var id: String = UUID().uuidString
    var reason: String
    var description: String
    var reporter: Profile
    var denounced: Profile
    
    var encoded: [String: Any] {
       let data = (try? JSONEncoder().encode(self)) ?? Data()
       return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    static func with(_ data: [String: Any]) throws -> AbusiveContent? {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(AbusiveContent.self, from: jsonData)
    }
}
