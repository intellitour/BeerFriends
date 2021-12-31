//
//  ProfileList.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import SwiftUI

struct FriendListView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State private var isShowing = false
    @ObservedObject private var friendProfileViewModel = FriendProfileViewModel()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.secondaryColor)]
    }
    
    var body: some View {
        NavigationView {
            ZStack() {
                if isShowing {
                    SideMenuView(isShowing: $isShowing)
                }
                ZStack {
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
                            }
                            .padding(.vertical, 7)
                        }
                    }
                    .onAppear {
                        friendProfileViewModel.fetchFriendsProfile()
                    }
                    .listStyle(PlainListStyle())
                    .background(colorScheme == .dark ? Color.black : Color.white)
                }
                .cornerRadius(isShowing ? 20 : 10)
                .offset(x: isShowing ? 300 : 0, y: 1)
                .scaleEffect(isShowing ? 0.8 : 1)
                .navigationBarItems(leading: Button(action: {
                    withAnimation(.spring()) {
                        isShowing.toggle()
                    }
                }, label: {
                    Image(systemName: K.Icon.SideMenu)
                        .foregroundColor(isShowing ? .primaryColor : .secondaryColor)
                }))
                .onAppear {
                    isShowing = false
                }
                .navigationTitle("Amigos")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
            //.preferredColorScheme(.dark)
    }
}
