//
//  ProfileViewModel.swift
//  BeerFriends
//
//  Created by Wesley Marra on 11/12/21.
//

import SwiftUI
import Combine

class ProfileViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @ObservedObject var profileRepository = ProfileRepository()
    @Published var profile = Profile()
    @Published var profileListSearch = [Profile]()
    @Published var profileSearchTerm = ""
    
    init() {
        profileRepository.$profile
            .filter({$0.uid != nil})
            .receive(on: DispatchQueue.main)
            .assign(to: \.profile, on: self)
            .store(in: &cancellables)
        
        profileRepository.$profileListSearch
            .filter{ !$0.isEmpty }
            .assign(to: \.profileListSearch, on: self)
            .store(in: &cancellables)
        
        $profileSearchTerm
            .debounce(for: .milliseconds(450), scheduler: RunLoop.main)
            .removeDuplicates()
            .compactMap{ $0 }
            .sink { (_) in
            } receiveValue: { [self] (searchField) in
                profileListSearch = []
                profileRepository.fetchProfiles(by: searchField)
            }.store(in: &cancellables)
    }
    
    func findProfile(by uid: String) {
        profileRepository.findProfile(by: uid)
    }
    
    func save(with profile: Profile,
              and photo: UIImage?,
              and imagesToRemove: [ProfileImages],
              and imagesToFavorite: [ProfileImages],
              and imagesToUnfavofite: [ProfileImages],
              completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        
        var profileWithImages = profile
        
        imagesToFavorite.forEach { profileImageUrl in
            if  profileWithImages.favoriteImagesURL == nil {
                profileWithImages.favoriteImagesURL = []
            }
            
            if !(profileWithImages.favoriteImagesURL?.contains(where: {$0 == profileImageUrl.imageURL}) ?? false) {
                profileWithImages.favoriteImagesURL?.append(profileImageUrl.imageURL!)
            }
        }
        
        imagesToUnfavofite.forEach { profileImageUrl in
            if  profileWithImages.favoriteImagesURL == nil {
                profileWithImages.favoriteImagesURL = []
            }
            
            if let index = profileWithImages.favoriteImagesURL?.firstIndex(of: profileImageUrl.imageURL!) {
                profileWithImages.favoriteImagesURL?.remove(at: index)
            }
        }
        
        imagesToRemove.forEach { profileImageUrl in
            profileWithImages.galleryImagesURL = profileWithImages.galleryImagesURL?.filter(){ $0 != profileImageUrl.imageURL }
            profileWithImages.favoriteImagesURL = profileWithImages.favoriteImagesURL?.filter(){ $0 != profileImageUrl.imageURL }
        }
        
        profileRepository.save(with: profileWithImages, and: photo, completionHandler: completionHandler)
    }
    
    func addImagesToEventsGallery(from profileUid: String,
                                  with image: UIImage,
                                  completionHandler: @escaping (HandleResult<URL>) -> Void) -> Void {
        profileRepository.addImagesToEventsGallery(from: profileUid, with: image, completionHandler: completionHandler)
    }
    
    func update(_ profile: Profile,
                completionHandler: @escaping (HandleResult<URL>) -> Void) -> Void {
        profileRepository.update(profile, completionHandler: completionHandler)
    }
}
