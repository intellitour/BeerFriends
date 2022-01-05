//
//  ProfileImages.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/12/21.
//

import SwiftUI

struct ProfileImages: Identifiable, Equatable, Codable {
    var id: String = UUID().uuidString
    var uid: String?
    var profileUid: String?
    var imageURL: URL?
}
