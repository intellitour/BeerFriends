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
    
    @Published var profile = Profile() {
        didSet {
            print(profile)
        }
    }
    
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
    
    func save(with profile: Profile, and photo: UIImage?) {
        profileRepository.save(with: profile, and: photo)
    }
}
