//
//  ProfileCircleView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import SwiftUI

struct FriendCircleView: View {
    let friendProfileItem: Profile
    
    var body: some View {
        ZStack(alignment: .leading) {
            if friendProfileItem.photoURL != nil {
                AsyncImage(url: friendProfileItem.photoURL)
                    .shadow(radius: 2)
                    .frame(width: 52, height: 52)
                    .overlay(
                        Circle().stroke(Color.secondaryColor, lineWidth: 2)
                    )
            } else {
                Text(friendProfileItem.name!.prefix(1).uppercased())
                       .shadow(radius: 2)
                       .font(.title2)
                       .foregroundColor(.secondaryColor)
                       .frame(width: 52, height: 52)
                       .overlay(
                         Circle().stroke(Color.secondaryColor, lineWidth: 2)
                       )
            }
        }
    }
}

struct ProfileCircleView_Previews: PreviewProvider {
    static var previews: some View {
        FriendCircleView(friendProfileItem: Profile())
    }
}
