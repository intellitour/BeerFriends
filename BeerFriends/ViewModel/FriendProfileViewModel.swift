//
//  FriendProfileViewModel.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import SwiftUI
import Combine

class FriendProfileViewModel: ObservableObject {
    private var cancellables: Set<AnyCancellable> = []
    
    @ObservedObject var friendRepository = FriendRepository()
    @Published var friendList = [Profile]()
    
    init() {
        friendRepository.$friendsProfile
            .receive(on: DispatchQueue.main)
            .assign(to: \.friendList, on: self)
            .store(in: &cancellables)
    }
    
    func fetchFriends(by profileUid: String) {
        friendRepository.fetchFriends(by: profileUid)
    }
    
    func addFriend(with profile: Profile,
                   and friendProfile: Profile,
                   completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        friendRepository.addFriend(with: profile, and: friendProfile, completionHandler: completionHandler)
    }
    
    func removeFriend(with friendId: String,
                   completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        friendRepository.removeFriend(with: friendId, completionHandler: completionHandler)
    }
}
