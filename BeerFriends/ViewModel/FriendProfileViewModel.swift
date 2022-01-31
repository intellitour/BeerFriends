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
    @Published var profile = Profile()
    @Published var friendList = [Profile]()
    @Published var friendsInvitation = [Profile]()
    
    init() {
        friendRepository.$friendsProfile
            .receive(on: DispatchQueue.main)
            .assign(to: \.friendList, on: self)
            .store(in: &cancellables)
        
        friendRepository.$friendsInvitation
            .receive(on: DispatchQueue.main)
            .assign(to: \.friendsInvitation, on: self)
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
    
    func refuseFriend(with profile: Profile,
                   and friendProfile: Profile,
                   completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        friendRepository.refuseFriend(with: profile, and: friendProfile, completionHandler: completionHandler)
    }
    
    func removeFriend(with friendId: String,
                      and profileId: String,
                      completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        friendRepository.removeFriend(with: friendId, and: profileId, completionHandler: completionHandler)
    }
    
    func follow(with profile: Profile,
                and friend: Profile,
                completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        friendRepository.follow(with: profile, and: friend, completionHandler: completionHandler)
    }
    
    func stopFollow(with profile: Profile,
                    and friend: Profile,
                    completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        friendRepository.stopFollow(with: profile, and: friend, completionHandler: completionHandler)
    }
    
    func findProfile(by uid: String,
                     completionHandler: @escaping (HandleResult<Profile>) -> Void) -> Void {
        friendRepository.findProfile(by: uid, completionHandler: completionHandler)
    }
    
    func listFriendsInvitation(with invitationsReceived: [String],
                               completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        friendRepository.listFriendsInvitation(with: invitationsReceived, completionHandler: completionHandler)
    }
    
    func denounce(with reason: String,
                  and description: String,
                  and reporter: Profile,
                  and denounced: Profile,
                  completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        friendRepository.denounce(with: reason, and: description, and: reporter, and: denounced, completionHandler: completionHandler)        
    }
    
    func checkComplaint(by reporterUid: String,
                        completionHandler: @escaping (HandleResult<AbusiveContent>) -> Void) -> Void {
        friendRepository.checkComplaint(by: reporterUid, completionHandler: completionHandler)
    }
    
    func blockUser(with profile: Profile,
                  and blockedFriend: Profile,
                  completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        var user = profile
        if user.blockedUsers == nil {
            user.blockedUsers = []
        }
        user.blockedUsers?.append(blockedFriend.uid!)
        friendRepository.blockUser(user, completionHandler: completionHandler)
    }
    
    func unblockUser(with profile: Profile,
                  and blockedFriend: Profile,
                  completionHandler: @escaping (HandleResult<Void>) -> Void) -> Void {
        
        var user = profile
        user.blockedUsers = user.blockedUsers?.filter(){ $0 != blockedFriend.uid! }
        friendRepository.unblockUser(user, completionHandler: completionHandler)
    }
}
