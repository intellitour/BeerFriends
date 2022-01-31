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
    @Published var friendsInvitation = [Profile]()
    @Published var friend = Profile()
    
    func addFriend(with profile: Profile,
              and profileFriend: Profile,
              completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        let batch = db.batch()
       
        if profile.invitationsReceived != nil && profile.invitationsReceived!.contains(where: {$0 == profileFriend.uid}) {
            var p = profile
            p.invitationsReceived = p.invitationsReceived?.filter(){ $0 != profileFriend.uid }
            
            let profileRef = self.db.collection("profiles").document(p.uid!)
            batch.updateData(p.encoded, forDocument: profileRef)
           
            let me = Friend(name: profile.name!, profileUid: profileFriend.uid!, friendProfile: p)
            let meFriendRef = self.db.collection("friends").document(profile.id + profileFriend.id)
            batch.setData(me.encoded, forDocument: meFriendRef)
            
            
            var f = profileFriend
            f.invitationsSent = f.invitationsSent?.filter(){ $0 != profile.uid }
            
            let friendProfileRef = self.db.collection("profiles").document(f.uid!)
            batch.updateData(f.encoded, forDocument: friendProfileRef)
                        
            let friend = Friend(name: profileFriend.name!, profileUid: profile.uid!, friendProfile: f)
            let friendRef = self.db.collection("friends").document(profileFriend.id + profile.id)
            batch.setData(friend.encoded, forDocument: friendRef)
            
            
            batch.commit() { error in
                if let error = error {
                    completionHandler(HandleResult(error: error))
                } else {
                    completionHandler(HandleResult(success: "Amigo adicionado com sucesso", data: f))
                }
            }
        } else {
            var p = profile
            if p.invitationsSent == nil {
                p.invitationsSent = []
            }
            p.invitationsSent!.append(profileFriend.uid!)
            
            let profileRef = self.db.collection("profiles").document(profile.uid!)
            batch.updateData(p.encoded, forDocument: profileRef)
            
                        
            var f = profileFriend
            if f.invitationsReceived == nil {
                f.invitationsReceived = []
            }
            f.invitationsReceived?.append(profile.uid!)
               
            let friendProfileRef = self.db.collection("profiles").document(profileFriend.uid!)
            batch.updateData(f.encoded, forDocument: friendProfileRef)
            
            
            batch.commit() { error in
                if let error = error {
                    completionHandler(HandleResult(error: error))
                } else {
                    completionHandler(HandleResult(success: "Pedido de amizade realizado com sucesso"))
                }
            }
        }
    }
    
    func refuseFriend(with profile: Profile,
              and profileFriend: Profile,
              completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        var p = profile
        p.invitationsReceived = p.invitationsReceived?.filter(){ $0 != profileFriend.uid }
        p.invitationsSent = p.invitationsSent?.filter() { $0 != profileFriend.uid}
        
        self.db.collection("profiles").document(p.uid!).updateData(p.encoded) { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            }
            completionHandler(HandleResult(success: "Pedido de amizade recusado com sucesso", data: profileFriend))
        }
    }
    
    func fetchFriends(by profileUid: String) {
        
        db.collection("friends").whereField("profileUid", isEqualTo: profileUid).addSnapshotListener { querySnapshot, error in
            guard let friendsDocuments = querySnapshot?.documents else {
                print("Não há amigos")
                return
            }
            
            self.friendsProfile = []
            friendsDocuments.forEach { queryDocumentSnapshot in
                let data = queryDocumentSnapshot.data()
                let friend = try! Friend.with(data)
                
                let docRef = self.db.collection("profiles").document(friend!.friendProfile.uid!)

                 docRef.getDocument { (document, error) in
                    guard error == nil else {
                        print("Erro ao recuperar documento do amigo \(String(describing: friend?.friendProfile.uid))")
                        return
                    }

                    if let document = document, document.exists {
                        let data = document.data()
                        if let data = data {
                            self.friendsProfile.append(try! Profile.with(data)!)
                            self.friendsProfile = self.friendsProfile.sorted(by: { $0.name! < $1.name! })
                        }
                    }
                }
            }
        }
    }
    
    func removeFriend(with friendId: String,
                      and profileId: String,
                      completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        let batch = db.batch()
       
        let meRef = self.db.collection("friends").document(profileId + friendId)
        batch.deleteDocument(meRef)
        
        let friendRef = self.db.collection("friends").document(friendId + profileId)
        batch.deleteDocument(friendRef)
        
        batch.commit() { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            } else {
                completionHandler(HandleResult(success: "Amigo removido com sucesso"))
            }
        }
    }
    
    func findProfile(by uid: String,
                     completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        let docRef = db.collection("profiles").document(uid)

        docRef.getDocument { (document, error) in
            guard error == nil else {
                completionHandler(HandleResult(error: error))
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    completionHandler(HandleResult(data: try! Profile.with(data) ?? Profile()))
                }
            }
        }
    }
    
    func follow(with profile: Profile,
                and friend: Profile,
                completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        var p = profile
        if p.following == nil {
            p.following = []
        }
        p.following?.append(friend.uid!)
        
        var f = friend
        if f.followers == nil {
            f.followers = []
        }
        f.followers?.append(profile.uid!)
        
        let batch = db.batch()
       
        let profileRef = self.db.collection("profiles").document(profile.uid!)
        batch.updateData(p.encoded, forDocument: profileRef)
        
        let friendProfileRef = self.db.collection("profiles").document(friend.uid!)
        batch.updateData(f.encoded, forDocument: friendProfileRef)
        
        batch.commit() { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            } else {
                completionHandler(HandleResult(success: "Você está seguindo \(friend.name!)"))
            }
        }
    }
    
    func stopFollow(with profile: Profile,
                    and friend: Profile,
                    completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        var p = profile
        p.following = p.following?.filter(){ $0 != friend.uid }
        
        var f = friend
        f.followers = f.followers?.filter(){ $0 != profile.uid }
        
        let batch = db.batch()
       
        let profileRef = self.db.collection("profiles").document(p.uid!)
        batch.updateData(p.encoded, forDocument: profileRef)
        
        let friendProfileRef = self.db.collection("profiles").document(f.uid!)
        batch.updateData(f.encoded, forDocument: friendProfileRef)
        
        batch.commit() { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            } else {
                completionHandler(HandleResult(success: "Você parou de seguir \(friend.name!)"))
            }
        }
    }
    
    func listFriendsInvitation(with invitationsReceived: [String],
                               completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        db.collection("profiles").whereField("uid", in: invitationsReceived).addSnapshotListener { querySnapshot, error in
            guard let friendsDocuments = querySnapshot?.documents else {
                completionHandler(HandleResult(error: error))
                return
            }
            
            let friends = friendsDocuments.map { (queryDocumentSnapshot) -> Profile in
                let data = queryDocumentSnapshot.data()
                return try! Profile.with(data)!
            }
            
            self.friendsInvitation = friends.sorted(by: { $0.name! < $1.name! })
        }
    }
    
    func denounce(with reason: String,
                  and description: String,
                  and reporter: Profile,
                  and denounced: Profile,
                  completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        let abusiveContent = AbusiveContent(reason: reason,
                                            description: description,
                                            reporter: reporter,
                                            denounced: denounced)
        
        db.collection("complaint").document(reporter.uid!).setData(abusiveContent.encoded) { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            } else {
                completionHandler(HandleResult(success: "Denúncia registrada com sucesso"))
            }
        }
    }
    
    func checkComplaint(by reporterUid: String,
                     completionHandler: @escaping (HandleResult<AbusiveContent>) -> Void) -> Void {
        
        let docRef = db.collection("complaint").document(reporterUid)

        docRef.getDocument { (document, error) in
            guard error == nil else {
                completionHandler(HandleResult(error: error))
                return
            }

            if let document = document, document.exists {
                let data = document.data()
                if let data = data {
                    completionHandler(HandleResult(data: try! AbusiveContent.with(data)!))
                }
            }
        }
    }
    
    func blockUser(_ user: Profile,
                        completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        self.db.collection("profiles").document(user.uid!).updateData(user.encoded) { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            }
            completionHandler(HandleResult(success: "Usuário bloqueado com sucesso.", data: user))
        }
    }
    
    func unblockUser(_ user: Profile,
                        completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        self.db.collection("profiles").document(user.uid!).updateData(user.encoded) { error in
            if let error = error {
                completionHandler(HandleResult(error: error))
            }
            completionHandler(HandleResult(success: "Usuário desbloqueado com sucesso.", data: user))
        }
    }
}
