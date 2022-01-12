//
//  FriendRepository.swift
//  BeerFriends
//
//  Created by Wesley Marra on 06/01/22.
//

import Foundation
import Firebase


class FriendRepository: ObservableObject {
    private let db = Firestore.firestore()
    
    @Published var friendsProfile = [Profile]()
    
    func addFriend(with profile: Profile,
              and profileFriend: Profile,
              completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        let friend = Friend(name: profileFriend.name!, profileUid: profile.uid!, friendProfile: profileFriend)
                
        self.db.collection("friends").document(profileFriend.id).setData(friend.encoded) { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            }
            completionHandler(HandleResult(success: "Amigo adicionado com sucesso"))
        }
    }
    
    func fetchFriends(by profileUid: String) {
        
        db.collection("friends").whereField("profileUid", isEqualTo: profileUid).addSnapshotListener { querySnapshot, error in
            guard let friendsDocuments = querySnapshot?.documents else {
                print("Não há amigos")
                return
            }
            
            let friends = friendsDocuments.map { (queryDocumentSnapshot) -> Profile in
                let data = queryDocumentSnapshot.data()
                let friend = try! Friend.with(data)
                return friend!.friendProfile
            }
            
            self.friendsProfile = friends.sorted(by: { $0.name! < $1.name! })
        }
    }
    
    func removeFriend(with friendId: String,
                   completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        db.collection("friends").document(friendId).delete() { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            } else {
                completionHandler(HandleResult(success: "Amigo removido com sucesso"))
            }
        }
    }
}
