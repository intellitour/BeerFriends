//
//  Settings.swift
//  BeerFriends
//
//  Created by Wesley Marra on 15/01/22.
//

import Foundation

struct Settings: Identifiable, Codable {
    var id: String = UUID().uuidString
    var isDarkMode = false
    var isBlockInvitation = false
    var isShowPhone = false


    var encoded: [String: Any] {
       let data = (try? JSONEncoder().encode(self)) ?? Data()
       return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    static func with(_ data: [String: Any]) throws -> Settings? {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(Settings.self, from: jsonData)
    }
}
