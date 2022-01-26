//
//  Friend.swift
//  BeerFriends
//
//  Created by Wesley Marra on 06/01/22.
//

import Foundation
import FirebaseFirestore

struct Friend: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var profileUid: String
    var friendProfile: Profile
    
    var encoded: [String: Any] {
       let data = (try? JSONEncoder().encode(self)) ?? Data()
       return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    static func with(_ data: [String: Any]) throws -> Friend? {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(Friend.self, from: jsonData)
    }
}
