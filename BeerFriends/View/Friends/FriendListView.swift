//
//  ProfileList.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import SwiftUI

struct FriendListView: View {
    
    @ObservedObject private var friendProfileViewModel = FriendProfileViewModel()
    
    var body: some View {
        NavigationView {
            List(friendProfileViewModel.friendList) { friendProfileItem in
                NavigationLink(destination: EmptyView()) {
                    HStack {
                      FriendCircleView(friendProfileItem: friendProfileItem)
                        VStack(alignment: .leading) {
                            Text(friendProfileItem.name ?? "")
                                .font(.headline)
                                .foregroundColor(.secondaryColor)
                            Text(friendProfileItem.email ?? "")
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                    }.padding(.vertical, 7)
                }
              }
              .navigationBarTitle("Amigos")
              .onAppear {
                  self.friendProfileViewModel.fetchFriendsProfile()
              }
            }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
    }
}
