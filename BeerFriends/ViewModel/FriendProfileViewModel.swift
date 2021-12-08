//
//  FriendProfileViewModel.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import SwiftUI
import Combine

class FriendProfileViewModel: ObservableObject {
    @ObservedObject var profileRepository = ProfileRepository()
    
    @Published var friendList = [Profile]()
    
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        profileRepository.$friendsProfile
            .assign(to: \.friendList, on: self)
            .store(in: &cancellables)
    }
    
    func fetchFriendsProfile() {
        profileRepository.fetchFriendsProfile()
    }
}
