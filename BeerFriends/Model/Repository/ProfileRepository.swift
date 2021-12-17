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
    @Published var profile = Profile()
    
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
    
    func findProfile(by uid: String) {
        let docRef = db.collection("profiles").document(uid)

        docRef.getDocument { (document, error) in
            guard error == nil else {
                print("error", error ?? "")
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    self.profile = try! Profile.with(data) ?? Profile()
                }
            }
        }
    }
}
