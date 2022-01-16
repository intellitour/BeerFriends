//
//  FriendProfileView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 12/01/22.
//

import SwiftUI
import AlertToast

struct FriendProfileView: View {
    
    @State var offset: CGFloat = 0
    @State var titleOffset: CGFloat = 0
    @State var galleryIndex = 0
    @State var friendProfile: Profile
    @State var loading = false
    @State var success: String?
    @State var error: String?
    @State var showSuccess = false
    @State var showError = false
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @StateObject var profileViewModel = ProfileViewModel()
    @ObservedObject var friendProfileViewModel = FriendProfileViewModel()
    
    func getProfile() {
        if userSessionStoreViewModel.userSession?.uid != nil {
            profileViewModel.findProfile(by: userSessionStoreViewModel.userSession?.uid ?? "")
        }
    }
    
    func reloadFriend() {
        friendProfileViewModel.findProfile(by: friendProfile.uid ?? "") { ( completionHandler ) in
            if completionHandler.error == nil && completionHandler.data != nil {
                self.friendProfile = completionHandler.data!
            }
        }
    }
    
    func isFollowing() -> Bool {
        return (profileViewModel.profile.following?.contains(where: {$0 == friendProfile.uid!})) ?? false
    }
    
    func follow() {
        loading = true
        
        friendProfileViewModel.follow(with: profileViewModel.profile, and: friendProfile)  { ( completionHandler ) in
            
            loading = false
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
                self.getProfile()
                self.reloadFriend()
            }
        }
    }
    
    func stopFollow() {
        loading = true
        
        friendProfileViewModel.stopFollow(with: profileViewModel.profile, and: friendProfile)  { ( completionHandler ) in
            
            loading = false
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
                self.getProfile()
                self.reloadFriend()
            }
        }
    }
    
    func getTitleTextOffset() -> CGFloat {
        let progress = 20 / titleOffset
        let offset = 60 * (progress > 0 && progress <= 1 ? progress : 1)
        return offset
    }
    
    func getOffset() -> CGFloat {
        let progress = (-offset / 80) * 20
        return progress <= 20 ? progress : 20
    }

    func blurViewOpacity() -> Double {
        let progress = -(offset + 80) / 150
        return Double(-offset > 80 ? progress : 0)
    }
    
    func getScale() -> CGFloat {
        let progress = -offset / 80
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        return scale < 1 ? scale : 1
    }
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        let x = proxy.frame(in: .global).minX
        let diff = abs(x - 60)
        
        if diff < 100 {
            scale = 1 + (100 - diff) / 700
        }
        return scale
    }
    
    func getGalleryImages(urls: [URL]) -> some View {
        return ScrollView {
            if urls.isEmpty {
                ZStack {
                    Image("GalleryImages")
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                        .opacity(0.2)
                    
                    Text("Seu amigo ainda não adicionou imagens!")
                        .font(.title2.bold())
                        .foregroundColor(.secondaryColor)
                        .multilineTextAlignment(.center)
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 50) {
                        ForEach(urls, id: \.self) { url in
                            GeometryReader { proxy in
                                let scale = getScale(proxy: proxy)
                                
                                AsyncImage(
                                    url: url,
                                    content: { image in
                                        NavigationLink(destination:
                                                        image.resizable()
                                                        .scaledToFill()
                                                        .ignoresSafeArea()
                                        ) {
                                            image .resizable()
                                                .scaledToFill()
                                                .frame(width: 250)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5)
                                                )
                                                .clipped()
                                                .cornerRadius(15)
                                                .shadow(radius: 5)
                                                .scaleEffect(CGSize(width: scale, height: scale))
                                        }
                                    },
                                    placeholder: {
                                        ProgressView()
                                            .frame(width: scale, height: scale, alignment: .center)
                                    })
                            }
                            .frame(width: 240, height: UIScreen.main.bounds.height / 2)
                        }
                    }
                    .padding(32)
                }
            }
        }
    }
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false,
            content: {
            
            VStack(spacing: 15) {
                GeometryReader { proxy -> AnyView in
                    let minY = proxy.frame(in: .global).minY
                    
                    DispatchQueue.main.async {
                        self.offset = minY
                    }
                    
                    return AnyView(
                        ZStack {
                            LinearGradient(gradient: Gradient(colors: [Color.secondaryColor, Color.primaryColor]),
                                           startPoint: .top,
                                           endPoint: .bottom
                            )
                            
                            HStack {
                                Button(action: {
                                    presentationMode.wrappedValue.dismiss()
                                }, label: {
                                    Image(systemName: K.Icon.ArrowLeft)
                                        .resizable()
                                        .foregroundColor(.primaryColor)
                                        .frame(width: 25, height: 25)
                                })
                                .padding(.bottom, 20)
                                
                                Spacer()
                                
                                Image(K.System.Icon)
                                    .resizable()
                                    .foregroundColor(.primaryColor)
                                    .frame(width: 30, height: 30)
                                    .padding(8.5)
                                    .background(Color.primaryColor)
                                    .cornerRadius(30)
                                VStack {
                                    Text("Beer Friends")
                                        .foregroundColor(.primaryColor)
                                        .fontWeight(.bold)
                                        .font(.title)
                                    Text("O lugar dos amigos")
                                        .foregroundColor(.primaryColor)
                                        .font(.subheadline)
                                }
                                .padding(.trailing, 30)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            BlurView()
                                .opacity(blurViewOpacity())
                            
                            VStack(spacing: 5) {
                                Text(friendProfile.name ?? "")
                                    .fontWeight(.bold)
                                    .foregroundColor(colorScheme == .dark ? Color.secondaryColor : Color.primaryColor)
                            }
                            .offset(y: 120)
                            .offset(y: titleOffset > 100 ? 0 : -getTitleTextOffset())
                            .opacity(titleOffset < 100 ? 1 : 0)
                        }
                        .clipped()
                        .frame(height: minY > 0 ? 180 + minY : nil)
                        .offset(y: minY > 0 ? -minY : -minY < 80 ? 0 : -minY - 80)
                    )
                }
                .frame(height: 180)
                .zIndex(1)
                
                VStack {
                    HStack {
                        if  friendProfile.photoURL != nil {
                            AsyncImage(
                                url: friendProfile.photoURL,
                                content: { image in
                                    NavigationLink(destination:
                                                    image
                                                    .resizable()
                                                    .scaledToFill()
                                                    .ignoresSafeArea()
                                    ) {
                                        image.resizable()
                                             .scaledToFill()
                                             .frame(width: 85, height: 85)
                                             .clipShape(Circle())
                                             .foregroundColor(.secondaryColor)
                                             .padding(6)
                                             .background(colorScheme == .dark ? Color.black : Color.white)
                                             .clipShape(Circle())
                                             .offset(y: offset < 0 ? getOffset() - 20 : -20)
                                             .scaleEffect(getScale())
                                    }
                               },
                               placeholder: {
                                   ProgressView()
                                       .frame(width: 85, height: 85, alignment: .center)
                               })
                        } else {
                            Image(systemName: K.Icon.CircleUser)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 85, height: 85)
                                .clipShape(Circle())
                                .foregroundColor(.secondaryColor)
                                .padding(6)
                                .background(colorScheme == .dark ? Color.black : Color.white)
                                .clipShape(Circle())
                                .offset(y: offset < 0 ? getOffset() - 20 : -20)
                                .scaleEffect(getScale())
                        }
                        
                        Spacer()
                        
                        Button(action: {isFollowing() ? stopFollow() : follow()}, label: {
                            Text(isFollowing() ? "Parar de seguir" : "Seguir")
                                .foregroundColor(.secondaryColor)
                                .fontWeight(.bold)
                                .padding(.vertical, 10)
                                .padding(.horizontal)
                                .background(
                                    Capsule()
                                        .stroke(Color.secondaryColor, lineWidth: 2)
                                )
                        })
                    }
                    .padding(.top, -25)
                    .padding(.bottom, -15)
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text(friendProfile.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondaryColor)
                        
                        Text(friendProfile.email ?? "")
                            .foregroundColor(.gray)
                            .padding(.top, -8)
                            .padding(.bottom, 8)
                        
                        Text(friendProfile.statusMessage ?? "")
                        
                        HStack(spacing: 5) {
                            Text(String(friendProfile.followers?.count ?? 0))
                                .foregroundColor(.secondaryColor)
                                .fontWeight(.semibold)
                            
                            Text(friendProfile.followers?.count == 1 ? "Seguidor" : "Seguidores")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text(String(friendProfile.following?.count ?? 0))
                                .foregroundColor(.secondaryColor)
                                .fontWeight(.semibold)
                                .padding(.leading, 10)
                            
                            Text("Seguindo")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                        }
                        .padding(.top, 8)
                        .padding(.bottom, 8)
                        
                        VStack {
                            HStack {
                                Text("Galeria")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondaryColor)
                                    .padding(.top)
                                    .padding(.bottom, -1)
                                
                                Spacer()
                            }
                            
                            Divider()
                            
                            HStack {
                                Text("Favoritas")
                                    .font(.caption)
                                    .foregroundColor(galleryIndex == 0 ? .white : .secondaryColor.opacity(0.85))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 20)
                                    .background(Color.primaryColor.opacity(galleryIndex == 0 ? 1 : 0))
                                    .clipShape(Capsule())
                                    .onTapGesture {
                                        galleryIndex = 0
                                    }
                                
                                Text("Fotos e eventos")
                                    .font(.caption)
                                    .foregroundColor(galleryIndex == 1 ? .white : .secondaryColor.opacity(0.85))
                                    .fontWeight(.bold)
                                    .padding(.vertical, 6)
                                    .padding(.horizontal, 20)
                                    .background(Color.primaryColor.opacity(galleryIndex == 01 ? 1 : 0))
                                    .clipShape(Capsule())
                                    .onTapGesture {
                                        galleryIndex = 1
                                    }
                                
                                Spacer()
                            }
                            .padding(.top, 10)
                            
                            ZStack {
                                if (galleryIndex == 0) {
                                    getGalleryImages(urls: friendProfile.favoriteImagesURL ?? [])
                                } else {
                                    getGalleryImages(urls: friendProfile.galleryImagesURL ?? [])
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height / 1.5)
                            .padding(.top, 20)
                        }
                    })
                    .overlay(
                        GeometryReader { proxy -> Color in
                            let minY = proxy.frame(in: .global).minY
                            
                            DispatchQueue.main.async {
                                self.titleOffset = minY
                            }
                            
                            return Color.clear
                        }
                        .frame(width: 0, height: 0)
                        ,alignment: .top
                    )
                }
                .padding(.horizontal)
                .zIndex(-offset > 80 ? 0 : 1)
            }
        })
        .onAppear(perform: {
            getProfile()
            reloadFriend()
        })
        .ignoresSafeArea(.all, edges: .top)
        .toast(isPresenting: $showSuccess, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: self.success)
        })
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red), title: "Erro.", subTitle: self.error)
        })
    }
}

struct FriendProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserSessionStoreViewModel())
            .preferredColorScheme(.dark)
    }
}