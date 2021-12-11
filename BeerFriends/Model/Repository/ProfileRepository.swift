//
//  UserService.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import Foundation
import Firebase

class ProfileRepository: ObservableObject {
    private var db = Firestore.firestore()
    
    @Published var friendsProfile = [Profile]()
    
    func createProfile(profile: Profile) {
        db.collection("profiles").document(profile.uid!).setData(profile.encoded)
    }
    
    func fetchFriendsProfile() {
        db.collection("profiles").addSnapshotListener { querySnapshot, error in
            guard let friendsDocuments = querySnapshot?.documents else {
                print("Não há amigos")
                return
            }
            
            self.friendsProfile = friendsDocuments.map { (queryDocumentSnapshot) -> Profile in
                let data = queryDocumentSnapshot.data()
                return try! Profile.with(data)!
            }
        }
    }
}
