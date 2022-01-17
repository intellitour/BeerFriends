//
//  SideMenuHeaderView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 08/12/21.
//

import SwiftUI

struct SideMenuHeaderView: View {
    @Binding var isShowing: Bool
    @Binding var profile: Profile
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: {
                withAnimation(.spring()) {
                    isShowing.toggle()
                }
            }, label: {
                Image(systemName: K.Icon.Close)
                    .frame(width: 32, height: 32)
                    .foregroundColor(colorScheme == .dark ? Color.black : Color.white)
                    .padding()
            })

            VStack(alignment: .leading) {
                if  profile.photoURL != nil {
                    AsyncImage(
                        url: profile.photoURL,
                        content: { image in
                            image.resizable()
                                 .scaledToFill()
                                 .clipped()
                                 .frame(maxWidth: 80, maxHeight: 80)
                                 .clipShape(Circle())
                       },
                       placeholder: {
                           ProgressView()
                               .frame(width: 80, height: 80, alignment: .center)
                       })
                } else {
                    Image(systemName: K.Icon.CircleUser)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                        .frame(width: 64, height: 64)
                        .clipShape(Circle())
                        .padding(.bottom, 16)
                }
                                
                Text(profile.name ?? "")
                    .font(.system(size: 24, weight: .semibold))
                
                Text(profile.email ?? "")
                    .font(.system(size: 14))
                    .padding(.bottom, 24)
                
                HStack(spacing: 12) {
                    HStack(spacing: 4) {
                        Text(String(profile.followers?.count ?? 0)).bold()
                        Text(profile.followers?.count == 1 ? "Seguidor" : "Seguidores")
                    }
                    
                    HStack(spacing: 4) {
                        Text(String(profile.following?.count ?? 0)).bold()
                        Text("Seguindo")
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

struct SideMenuHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        SideMenuHeaderView(isShowing: .constant(true), profile: .constant(Profile()))
    }
}
