//
//  UserService.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import Foundation
import Firebase
import UIKit

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
                    self.profile.galleryImagesUrls = self.getUrlsFake()
                }
            }
        }
    }
    
    func save(with profile: Profile,
              and photo: UIImage?,
              completionHandler: @escaping (HandleResult) -> Void) -> Void {
        
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
    
    func getUrlsFake() -> [URL] {
        return [
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage1.jpg?alt=media&token=44a11f89-6fc0-462e-b0be-be12bafd217d")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage10.jpg?alt=media&token=b7fbbaa6-c07b-4053-b43c-de6a55711474")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage11.jpg?alt=media&token=46c40d9c-b8e8-48ec-8647-41854816b34e")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage12.jpg?alt=media&token=7f55f6f8-db2e-4c67-b7f9-a1c0333eafb7")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage13.jpg?alt=media&token=7a916921-9486-4661-b97b-cc69ac3e521e")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage14.jpg?alt=media&token=4031a17e-6d2d-40fc-aa47-d0f359866aca")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage15.jpg?alt=media&token=54786e8e-17df-4ac0-a351-c4d6832b2326")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage2.jpg?alt=media&token=e094c586-4d4c-45c6-8155-52efcfe08068")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage3.jpg?alt=media&token=1e53127f-81f6-487e-a320-2f7ee65f25b2")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage4.jpg?alt=media&token=192e11b2-34f2-4578-ae83-17c9fab89136")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage5.jpg?alt=media&token=7302a3e5-5ad3-4456-876b-ddf79362da9c")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage6.jpg?alt=media&token=c21c8103-598b-4ee1-a1fc-5738f81086f5")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage7.jpg?alt=media&token=dd5d9b95-0c00-499e-94b5-3bf7e1015cfd")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage8.jpg?alt=media&token=28472374-45f7-4ffc-abe2-69db6ad78781")!,
            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/gallery%2Fimage9.jpg?alt=media&token=6fa4c4ed-dcd2-498c-87e5-ca40345aee2e")!
        ]
    }
}
