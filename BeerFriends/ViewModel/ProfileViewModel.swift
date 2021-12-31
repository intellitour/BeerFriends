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
    
    init() {
        profileRepository.$profile
            .filter({$0.uid != nil})
            .receive(on: DispatchQueue.main)
            .assign(to: \.profile, on: self)
            .store(in: &cancellables)
        }
    
    func findProfile(by uid: String) {
        profileRepository.findProfile(by: uid)
    }
    
    func save(with profile: Profile,
              and photo: UIImage?,
              completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        profileRepository.save(with: profile, and: photo, completionHandler: completionHandler)
    }
    
    func addImagesToEventsGallery(from profileUid: String,
                                  with image: UIImage,
                                  completionHandler: @escaping (HandleResult<URL>) -> Void) -> Void {
        profileRepository.addImagesToEventsGallery(from: profileUid, with: image, completionHandler: completionHandler)
    }
}
