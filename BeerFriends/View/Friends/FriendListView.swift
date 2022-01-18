//
//  ProfileList.swift
//  BeerFriends
//
//  Created by Wesley Marra on 07/12/21.
//

import SwiftUI
import AlertToast

struct FriendListView: View {
    
    @State private var isShowing = false
    @State private var showSearchFriends = false
    
    @State var loading = false
    @State var success: String?
    @State var error: String?
    @State var showSuccess = false
    @State var showError = false
    
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    
    @StateObject var profileViewModel = ProfileViewModel()
    @ObservedObject var friendProfileViewModel = FriendProfileViewModel()
    
    init() {
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor(Color.secondaryColor)]
    }
    
    func onInit() {
        getProfile()
        friendProfileViewModel.fetchFriends(by: userSessionStoreViewModel.userSession?.uid ?? "")
        isShowing = false
    }
    
    func getProfile() {
        if userSessionStoreViewModel.userSession?.uid != nil {
            profileViewModel.findProfile(by: userSessionStoreViewModel.userSession?.uid ?? "")
        }
    }
    
    func removeRows(with friend: Profile) {
        loading = true
        friendProfileViewModel.removeFriend(with: friend.id, and: profileViewModel.profile.id) { ( completionHandler ) in
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
            }
            
            loading = false
        }
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                if isShowing {
                    SideMenuView(isShowing: $isShowing)
                }
                ZStack {
                    List(friendProfileViewModel.friendList) { friendProfileItem in
                        NavigationLink(destination: FriendProfileView(friendProfile: friendProfileItem).navigationBarHidden(true)) {
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
                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                            Button(role: .destructive) {
                               removeRows(with: friendProfileItem)
                            } label: {
                                Label("Remover", systemImage: K.Icon.RemoveUser)
                            }
                        }
                       
                    }
                    .listStyle(PlainListStyle())
                    .background(colorScheme == .dark ? Color.black : Color.white)
                    
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button(action: {
                                showSearchFriends.toggle()
                            }) {
                                Image(systemName: K.Icon.Plus)
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.primaryColor)
                                    .padding()
                                    .cornerRadius(30)
                            }
                            .background(Color.secondaryColor)
                            .cornerRadius(35)
                            .padding()
                            .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                            .fullScreenCover(isPresented: $showSearchFriends,
                                             content: { SearchFriendsView(friendList: friendProfileViewModel.friendList) })
                        }
                    }
                }
                .cornerRadius(isShowing ? 20 : 10)
                .offset(x: isShowing ? 300 : 0, y: 1)
                .scaleEffect(isShowing ? 0.8 : 1)
                .navigationBarItems(
                    leading: Button(
                        action: {
                            withAnimation(.spring()) {
                                isShowing.toggle()
                            }
                        }, label: {
                            Image(systemName: K.Icon.SideMenu)
                                .foregroundColor(isShowing ? .primaryColor : .secondaryColor)
                        }),
                    trailing: Button(
                        action: {},
                        label: {
                            if profileViewModel.profile.invitationsReceived?.isEmpty == false {
                                NavigationLink(destination: FriendInvitationView(profile: profileViewModel.profile).navigationBarHidden(true)) {
                                    Image(systemName: K.Icon.InvitationPending)
                                        .foregroundColor(.secondaryColor)
                                }
                            }
                        })
                )
                .onAppear(perform: onInit)
                .navigationTitle("Amigos")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
        .toast(isPresenting: $showSuccess, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: self.success)
        })
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red),title: "Erro ao remover amigo.", subTitle: self.error)
        })
    }
}

struct FriendListView_Previews: PreviewProvider {
    static var previews: some View {
        FriendListView()
            //.preferredColorScheme(.dark)
    }
}
