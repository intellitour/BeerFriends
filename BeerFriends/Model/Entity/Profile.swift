//
//  UserProfile.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import Foundation

struct Profile: Identifiable, Codable {
    var id: String = UUID().uuidString
    var uid: String?
    var email: String?
    var name: String?
    var phone: String?
    var statusMessage: String?
    var level: String?
    var photoURL: URL?
    var amountDifferentBeers: Int?
    var localization: Localization?
    var favoritePlaces: [Localization]?
    
    var encoded: [String: Any] {
       let data = (try? JSONEncoder().encode(self)) ?? Data()
       return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    static func with(_ data: [String: Any]) throws -> Profile? {
        let jsonData = try JSONSerialization.data(withJSONObject: data, options: [])
        return try JSONDecoder().decode(Profile.self, from: jsonData)
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case name
        case phone
        case statusMessage
        case level
        case photoURL
        case amountDifferentBeers
        case localization
        case favoritePlaces
    }
}

struct Localization: Codable {
    var latitude: String;
    var longitude: String;
}
