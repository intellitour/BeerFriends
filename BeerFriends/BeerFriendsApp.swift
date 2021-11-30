//
//  BeerFriendsApp.swift
//  BeerFriends
//
//  Created by Wesley Marra on 17/11/21.
//

import SwiftUI
import Firebase

@main
struct BeerFriendsApp: App {
    init() {
        FirebaseApp.configure()
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(SessionStore())
        }
    }
}
