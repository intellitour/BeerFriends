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
    var level: String?
    var photoURL: URL?
    var amountDifferentBeers: Int?
    var localization: Localization?
    var favoritePlaces: [Localization]?
    
    var profileEncoded: [String: Any] {
       let data = (try? JSONEncoder().encode(self)) ?? Data()
       return (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]) ?? [:]
    }
    
    enum CodingKeys: String, CodingKey {
        case uid
        case email
        case name
    }
}

struct Localization: Codable {
    var latitude: String;
    var longitude: String;
}
