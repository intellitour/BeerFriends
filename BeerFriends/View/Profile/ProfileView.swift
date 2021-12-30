//
//  ProfileView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 10/12/21.
//

import SwiftUI

struct ProfileView: View {
    
    @State var offset: CGFloat = 0
    @State var titleOffset: CGFloat = 0
    @State var galleryIndex = 0
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @StateObject var viewModel = ProfileViewModel()
    
    func getProfile() {
        if userSessionStoreViewModel.userSession?.uid != nil {
            viewModel.findProfile(by: userSessionStoreViewModel.userSession?.uid ?? "")
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
    
    func getScale() -> CGFloat {
        let progress = -offset / 80
        let scale = 1.8 - (progress < 1.0 ? progress : 1)
        return scale < 1 ? scale : 1
    }
    
    func blurViewOpacity() -> Double {
        let progress = -(offset + 80) / 150
        return Double(-offset > 80 ? progress : 0)
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
                                Text(viewModel.profile.name ?? "")
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
                        if  viewModel.profile.photoURL != nil {
                            AsyncImage(
                                url: viewModel.profile.photoURL,
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
                            Image(systemName: K.Icon.PersonCircle)
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
                        
                        Button(action: {}, label: {
                            NavigationLink(destination: ProfileEditView(profile: viewModel.profile).navigationBarHidden(true)) {
                                Text("Editar Perfil")
                                    .foregroundColor(.secondaryColor)
                                    .fontWeight(.bold)
                                    .padding(.vertical, 10)
                                    .padding(.horizontal)
                                    .background(
                                        Capsule()
                                            .stroke(Color.secondaryColor, lineWidth: 2)
                                    )
                            }
                        })
                    }
                    .padding(.top, -25)
                    .padding(.bottom, -15)
                    
                    VStack(alignment: .leading, spacing: 8, content: {
                        Text(viewModel.profile.name ?? "")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondaryColor)
                        
                        Text(viewModel.profile.email ?? "")
                            .foregroundColor(.gray)
                            .padding(.top, -8)
                            .padding(.bottom, 8)
                        
                        Text(viewModel.profile.statusMessage ?? "")
                        
                        HStack(spacing: 5) {
                            Text("32")
                                .foregroundColor(.secondaryColor)
                                .fontWeight(.semibold)
                            
                            Text("Seguidores")
                                .foregroundColor(.gray)
                                .font(.subheadline)
                            
                            Text("114")
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
                                    FavoriteGalleryImagesView()
                                        .padding(.horizontal, 25)
                                } else {
                                    EventsGalleryImagesView()
                                }
                            }
                            .frame(height: UIScreen.main.bounds.height / 1.8)
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
        .ignoresSafeArea(.all, edges: .top)
        .onAppear(perform: getProfile)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserSessionStoreViewModel())
            .preferredColorScheme(.dark)
    }
}
