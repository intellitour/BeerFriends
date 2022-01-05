//
//  UserService.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import Foundation
import Firebase
import UIKit
import SwiftUI

class ProfileRepository: ObservableObject {
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    
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
    
    func save(with profile: Profile,
              and photo: UIImage?,
              completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        let storageRef = storage.reference().child("profiles/\(profile.uid!).jpg")
        if photo != nil {
            let data = photo?.jpegData(compressionQuality: 0.5)
            
            let metadata = StorageMetadata()
            metadata.contentType = "image/jpg"
            
            if let data = data {
                storageRef.putData(data, metadata: metadata) { (metadata, error) in
                    if let error = error {
                        completionHandler(HandleResult(error: error))
                        return
                    }
                    
                    storageRef.downloadURL { [self] (url, error) in
                        guard let downloadURL = url else { return }
                        
                        self.profile = profile
                        self.profile.photoURL = downloadURL
                        
                        self.db.collection("profiles").document(self.profile.uid!).updateData(self.profile.encoded) { error in
                            if let error = error {
                                completionHandler(HandleResult(error: error))
                            }
                            completionHandler(HandleResult(success: "Perfil salvo com sucesso"))
                        }
                    }
                }
            }
        } else {
            db.collection("profiles").document(profile.uid!).updateData(profile.encoded) { error in
                if let error = error {
                    completionHandler(HandleResult(error: error))
                }
                completionHandler(HandleResult(success: "Perfil salvo com sucesso"))
            }
        }
    }
    
    func addImagesToEventsGallery(from profileUid: String,
                                  with image: UIImage,
                                  completionHandler: @escaping (HandleResult<URL>) -> Void) -> Void {
        
        let data = image.jpegData(compressionQuality: 0.5)
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpg"
        
        if let data = data {
            let imageGallery = ProfileImages(profileUid: profileUid)
            let storageRef = storage.reference().child("gallery/events/\(profileUid)/\(imageGallery.id).jpg")
            
            storageRef.putData(data, metadata: metadata) { (metadata, error) in
                if let error = error {
                    completionHandler(HandleResult(error: error))
                    return
                }
                
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else { return }
                    
                    completionHandler(HandleResult(success: "Imagem adicionada com sucesso", data: downloadURL))
                }
            }
        }
        
    }
}
