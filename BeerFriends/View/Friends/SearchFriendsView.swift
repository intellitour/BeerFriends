//
//  SearchFriends.swift
//  BeerFriends
//
//  Created by Wesley Marra on 05/01/22.
//

import SwiftUI
import AlertToast

struct SearchFriendsView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @ObservedObject var friendProfileViewModel = FriendProfileViewModel()
    @StateObject var profileViewModel = ProfileViewModel()
    
    @State var loading = false
    @State var success: String?
    @State var error: String?
    @State var showSuccess = false
    @State var showError = false
    @State var friendList: [Profile]
    @State var isBlockInvitation = false
    
    func getProfile() {
        if userSessionStoreViewModel.userSession?.uid != nil {
            profileViewModel.findProfile(by: userSessionStoreViewModel.userSession?.uid ?? "")
        }
    }
    
    func addFriend(with friend: Profile) {
        
        if friend.isBlockInvitation == true {
            self.isBlockInvitation = true
            return
        }
        
        loading = true
        
        friendProfileViewModel.addFriend(with: profileViewModel.profile, and: friend) { completionHandler in
            loading = false
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
                
                if completionHandler.data != nil {
                    self.friendList.append(completionHandler.data!)
                } else {
                    getProfile()
                }
            }
        }
    }

    var body: some View {
        ZStack(alignment: .top) {
            (colorScheme == .dark ? Color.black : Color.white).edgesIgnoringSafeArea(.all)
            VStack {
                HStack {
                    TextField("Procurar amigo", text: $profileViewModel.profileSearchTerm)
                        .padding(.leading, 32)
                }
                .padding()
                .foregroundColor(.black)
                .background(.gray.opacity(0.2))
                .cornerRadius(12)
                .padding(.horizontal)
                .overlay(
                    HStack {
                        Image(systemName: K.Icon.Search)
                        Spacer()
                        if !profileViewModel.profileSearchTerm.isEmpty {
                            Button(action: {profileViewModel.profileSearchTerm = ""}) {
                                Image(systemName: K.Icon.CloseFill)
                            }
                        }
                    }
                    .padding(.horizontal, 32)
                    .foregroundColor(.gray)
                )
                .background(colorScheme == .dark ? Color.black : Color.white)
                
                List(profileViewModel.profileListSearch) { friendProfileItem in
                    if friendProfileItem.uid != userSessionStoreViewModel.userSession?.uid {
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
                            
                            if (profileViewModel.profile.invitationsSent ?? []).contains(where: {$0 == friendProfileItem.uid}) {
                                Image(systemName: K.Icon.InvitationReceived)
                                    .resizable()
                                    .foregroundColor(.gray)
                                    .opacity(0.5)
                                    .frame(width: 30, height: 25)
                            } else if friendList.contains(where: {$0.uid == friendProfileItem.uid}) {
                                Image(K.System.Icon)
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 16, height: 16)
                                    .padding(7)
                                    .background(colorScheme == .dark ? Color.secondaryColor : Color.primaryColor)
                                    .cornerRadius(16)
                            } else {
                                Image(systemName: K.Icon.InvitationSent)
                                    .resizable()
                                    .foregroundColor(.secondaryColor)
                                    .frame(width: 30, height: 25)
                                    .onTapGesture {
                                        addFriend(with: friendProfileItem)
                                    }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .background(colorScheme == .dark ? Color.black : Color.white)
                
                Button("Fechar") {
                    presentationMode.wrappedValue.dismiss()
                }
                .foregroundColor(Color.secondaryColor)
            }
        }
        .padding(.vertical)
        .onAppear(perform: {
            getProfile()
            profileViewModel.profileRepository.fetchProfiles(by: nil)
        })
        .toast(isPresenting: $showSuccess, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: self.success)
        })
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red), title: "Erro ao adiconar amigo.", subTitle: self.error)
        })
        .toast(isPresenting: $isBlockInvitation, alert: {
            AlertToast(type: .systemImage(K.Icon.RefuseUser, .yellow),
                       title: Optional("Indisponível"),
                       subTitle: Optional("O Usuário pediu privacidade"))
        })
    }
}

struct SearchFriendsView_Previews: PreviewProvider {
    static var previews: some View {
        SearchFriendsView(friendList: [])
            .preferredColorScheme(.dark)
    }
}
