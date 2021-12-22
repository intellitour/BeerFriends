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
                AsyncImage(
                    url: friendProfileItem.photoURL,
                    content: { image in
                       image.resizable()
                            .scaledToFill()
                            .clipped()
                            .frame(width: 52, height: 52)
                            .clipShape(Circle())
                   },
                   placeholder: {
                       ProgressView()
                           .frame(width: 52, height: 52, alignment: .center)
                   })
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
