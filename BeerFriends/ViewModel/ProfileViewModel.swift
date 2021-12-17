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
//        profileRepository.$profile
//            .filter({$0.uid != nil})
//            .sink(
//                receiveValue: { [weak self] profile in
//                    self?.profile = profile
//                })
//            .store(in: &cancellables)
        
        profileRepository.$profile
            .filter({$0.uid != nil})
            .receive(on: DispatchQueue.main)
            .assign(to: \.profile, on: self)
            .store(in: &cancellables)
        
//        profileRepository.$profile
//            .assign(to: &$profile)
    }
    
    func findProfile(by uid: String) {
        profileRepository.findProfile(by: uid)
    }
}
