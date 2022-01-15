//
//  FriendInvitationView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 14/01/22.
//

import SwiftUI
import AlertToast

struct FriendInvitationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject private var friendProfileViewModel = FriendProfileViewModel()
    
    @State var profile: Profile
    @State var loading = false
    @State var success: String?
    @State var error: String?
    @State var showSuccess = false
    @State var showError = false
    
    func listFriendsInvitation() {
        if profile.invitationsReceived != nil && !profile.invitationsReceived!.isEmpty {
            friendProfileViewModel.listFriendsInvitation(with: profile.invitationsReceived!) { (completionHandler) in
                if completionHandler.error != nil {
                    self.error = completionHandler.error?.localizedDescription
                    self.showError = true
                }
            }
        }
    }
    
    func addFriend(with friend: Profile) {
        loading = true
        
        friendProfileViewModel.addFriend(with: profile, and: friend) { completionHandler in
            loading = false
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
                
                if completionHandler.data != nil {
                    self.profile.invitationsReceived = self.profile.invitationsReceived!.filter(){ $0 != completionHandler.data?.uid! }
                    self.friendProfileViewModel.friendsInvitation = self.friendProfileViewModel.friendsInvitation.filter() { $0.id != completionHandler.data?.id}
                }
            }
        }
    }
    
    func refuseFriend(with friend: Profile) {
        loading = true
        
        friendProfileViewModel.refuseFriend(with: profile, and: friend) { completionHandler in
            loading = false
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
                
                if completionHandler.data != nil {
                    self.profile.invitationsReceived = self.profile.invitationsReceived!.filter(){ $0 != completionHandler.data?.uid! }
                    self.friendProfileViewModel.friendsInvitation = self.friendProfileViewModel.friendsInvitation.filter() { $0.id != completionHandler.data?.id}
                }
            }
        }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                List(friendProfileViewModel.friendsInvitation) { friendProfileItem in
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
                        .padding(.vertical, 7)
                        
                        Spacer()
                       
                        Image(systemName: K.Icon.ArrowLeft)
                            .foregroundColor(.secondaryColor)
                            .opacity(0.3)
                       
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                           refuseFriend(with: friendProfileItem)
                        } label: {
                            Label("Recusar", systemImage: K.Icon.RefuseUser)
                        }
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button() {
                            addFriend(with: friendProfileItem)
                        } label: {
                            Label("Aceitar", systemImage: K.Icon.AccpetUser)
                        }
                        .tint(.green)
                    }
                }
                .listStyle(PlainListStyle())
                .background(colorScheme == .dark ? Color.black : Color.white)
                .onAppear(perform: listFriendsInvitation)
            }
            .navigationTitle("Amizades Pendentes")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(
                    action: {
                        withAnimation(.spring()) {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }, label: {
                        Image(systemName: K.Icon.ArrowLeft)
                            .foregroundColor(.secondaryColor)
                    })
            )
        }
        .toast(isPresenting: $showSuccess, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: self.success)
        })
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red), title: "Erro ao adiconar amigo.", subTitle: self.error)
        })
    }
}

struct FriendInvitationView_Previews: PreviewProvider {
    static var previews: some View {
        FriendInvitationView(profile: Profile())
    }
}
