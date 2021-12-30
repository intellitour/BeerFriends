//
//  ProfileEditView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 13/12/21.
//

import SwiftUI
import AlertToast

struct ProfileEditView: View {
    
    // Mock
    @State var events = [
        Gallery(id: 0, image: "image1", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 1, image: "image2", offset: 0, title: "Chapada Diamantina"),
        Gallery(id: 2, image: "image3", offset: 0, title: "Por do sol"),
        Gallery(id: 3, image: "image4", offset: 0, title: "Barzinho na beira da praia"),
        Gallery(id: 4, image: "image5", offset: 0, title: "Cervejaria Vórtex BrewHouse"),
        Gallery(id: 5, image: "image6", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 6, image: "image7", offset: 0, title: "Chapada Diamantina"),
        Gallery(id: 7, image: "image8", offset: 0, title: "Por do sol"),
        Gallery(id: 8, image: "image9", offset: 0, title: "Barzinho na beira da praia"),
        Gallery(id: 9, image: "image10", offset: 0, title: "Cervejaria Vórtex BrewHouse"),
        Gallery(id: 10, image: "image11", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 11, image: "image12", offset: 0, title: "Chapada Diamantina"),
        Gallery(id: 12, image: "image13", offset: 0, title: "Por do sol"),
        Gallery(id: 13, image: "image14", offset: 0, title: "Barzinho na beira da praia"),
        Gallery(id: 14, image: "image15", offset: 0, title: "Cervejaria Vórtex BrewHouse")
    ]
    
    @Namespace var animation
    @State private var profileImage: UIImage? = nil
    @State private var image: UIImage? = nil
    @State private var showImageAction = false
    @State private var showImagePicker = false
    @State private var activeSheet: ActiveSheet?
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var profile: Profile
    @State var loading = false
    @State var success: String?
    @State var error: String?
    @State var showSuccess = false
    @State var showError = false
    @State var compositionalCardsImage: [[URL]] = []
    
    @State var imagesToAdd: [ProfileImages] = []
    @State var imagesToRemove: [ProfileImages] = []
    @State var imagesToFavorite: [ProfileImages] = []
    @State var imagesToUnfavorite: [ProfileImages] = []
    
    @ObservedObject var viewModel = ProfileViewModel()
        
    var sheet: ActionSheet {
       ActionSheet(
           title: Text("Selecione uma imagem"),
           message: Text("Escolha na galeria ou tire uma foto"),
           buttons: [
               .default(Text("Tirar foto"), action: {
                   showImageAction = false
                   showImagePicker = true
                   sourceType = .camera
               }),
               .cancel(Text("Cancelar"), action: {
                   showImageAction = false
               }),
               .default(Text("Escolher na geleria"), action: {
                   showImageAction = false
                   showImagePicker = true
                   sourceType = .photoLibrary
               })
           ])
    }
    
    func saveProfile() {
        self.loading = true
        self.showError = false
        self.showSuccess = false
                
        viewModel.save(with: Profile(id: profile.id,
                                     uid: profile.uid,
                                     email: profile.email,
                                     name: profile.name,
                                     phone: profile.phone,
                                     statusMessage: profile.statusMessage,
                                     photoURL: profile.photoURL),
                       and: profileImage) { ( completionHandler ) in
            
            loading = false
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
            }
        }
    }
    
    func createImagePlus(with padding: CGFloat, and lineWidth: CGFloat) -> some View {
        return Image(systemName: K.Icon.Plus)
            .foregroundColor(.primaryColor)
            .frame(width: 30, height: 30)
            .background(Color.secondaryColor)
            .clipShape(Circle())
            .padding(padding)
            .overlay(Circle().stroke(Color.primaryColor, lineWidth: lineWidth))
            .onTapGesture {
                showImageAction = true
                activeSheet = .profile
            }
    }
    
    func setCompositionalLayout() {
        compositionalCardsImage = []
        var currentArrayCards: [URL] = []
        
        profile.galleryImagesUrls?.forEach { (url) in
            currentArrayCards.append(url)
            
            if currentArrayCards.count == 3 {
                compositionalCardsImage.append(currentArrayCards)
                currentArrayCards.removeAll()
            }
            
            if currentArrayCards.count != 3 && currentArrayCards.description == currentArrayCards.last?.description {
                compositionalCardsImage.append(currentArrayCards)
                currentArrayCards.removeAll()
            }
        }
    }
        
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Image(systemName: K.Icon.ArrowLeft)
                            .resizable()
                            .foregroundColor(.primaryColor)
                            .frame(width: 25, height: 25)
                    })
                    .padding(EdgeInsets(top: 20, leading: 20, bottom: -20, trailing: 50))
                    
                    Spacer()
                }
                
                ZStack(alignment: .bottomTrailing) {
                    if self.profileImage != nil {
                        NavigationLink(destination:
                                        Image(uiImage: self.profileImage!)
                                        .resizable()
                                        .scaledToFill()
                                        .ignoresSafeArea()
                        ) {
                            Image(uiImage: self.profileImage!)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 150, height: 150)
                                .clipped()
                                .cornerRadius(150)
                                .shadow(radius: 2)
                        }
                        
                        createImagePlus(with: 8, and: 0)
                        
                    } else if profile.photoURL != nil {
                        AsyncImage(
                            url: profile.photoURL,
                            content: { image in
                                NavigationLink(destination:
                                                image.resizable()
                                                .scaledToFill()
                                                .ignoresSafeArea()
                                ) {
                                    image.resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 150)
                                        .clipped()
                                        .cornerRadius(150)
                                        .shadow(radius: 2)
                                }
                                
                                createImagePlus(with: 8, and: 0)
                           },
                           placeholder: {
                               ProgressView()
                                   .frame(width: 85, height: 85, alignment: .center)
                           })
                    } else {
                        Image(systemName: K.Icon.PersonCircle)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .foregroundColor(.secondaryColor)
                            .clipShape(Circle())
                            .onTapGesture {
                                showImageAction = true
                                activeSheet = .profile
                            }
                        
                        createImagePlus(with: 0, and: 3)
                    }
                }
                
                Text(profile.name ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryColor)
                
                Text(profile.email ?? "")
                    .foregroundColor(.black.opacity(0.5))
            }
            .padding(.bottom, 30)
            .background(.linearGradient(colors: [.primaryColor, .secondaryColor], startPoint: .bottom, endPoint: .top))
            
            if loading {
                Spacer()
                AlertToast(type: .loading)
                Spacer()
            } else {
                ScrollView {
                    VStack {
                        CustomTextField(image: K.Icon.PersonFill, title: "Nome", value: $profile.name.bound, animation: animation)
                            .textInputAutocapitalization(.words)
                        CustomTextField(image: K.Icon.Envelope, title: "E-mail", value: $profile.email.bound, animation: animation)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                        CustomTextField(image: K.Icon.Phone, title: "Telefone", value: $profile.phone.bound, animation: animation)
                            .keyboardType(.phonePad)
                        
                        ZStack {
                            HStack(alignment: .top) {
                                Image(systemName: K.Icon.StatusMessage)
                                    .font(.system(size: 22))
                                    .foregroundColor(.secondaryColor)
                                    .frame(width: 35)
                                    .padding(.top, 10)
                                
                                TextEditor(text: $profile.statusMessage.bound)
                                    .frame(width: UIScreen.main.bounds.width - 100)
                                    .textInputAutocapitalization(.sentences)
                                Text(profile.statusMessage ?? "").opacity(0).padding(.all, 8)
                            }
                        }
                        .frame(height: 150)
                        
                        Divider()
                        
                        VStack {
                            HStack(alignment: .center) {
                                Text("Galeria")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondaryColor)
                                    .padding(.top, 20)
                                    .padding(.bottom, -1)
                                
                                Spacer()
                                
                                Button(action: {}, label: {
                                    Label("Adicionar", systemImage: K.Icon.Photos)
                                        .font(.caption)
                                        .foregroundColor(.secondaryColor.opacity(0.85))
                                        .frame(width: 100, height: 25)
                                        .background(Color.primaryColor)
                                        .clipShape(Capsule())
                                        .padding(.top, 20)
                                        .padding(.bottom, -1)
                                        .onTapGesture {
                                            showImageAction = true
                                            activeSheet = .gallery
                                        }
                                })
                            }
                            
                            Divider()
                            
                            VStack(spacing: 4) {
                                ForEach(compositionalCardsImage.indices, id: \.self) {index in
                                    if index == 0 || index % 6 == 0 {
                                        LayoutOne(cards: compositionalCardsImage[index],
                                                  imagesToRemove: $imagesToRemove,
                                                  imagesToFavorite: $imagesToFavorite,
                                                  imagesToUnfavorite: $imagesToUnfavorite)
                                    } else if index % 3 == 0 {
                                        LayoutThree(cards: compositionalCardsImage[index],
                                                    imagesToRemove: $imagesToRemove,
                                                    imagesToFavorite: $imagesToFavorite,
                                                    imagesToUnfavorite: $imagesToUnfavorite)
                                    } else {
                                        LayoutTwo(cards: compositionalCardsImage[index],
                                                  imagesToRemove: $imagesToRemove,
                                                  imagesToFavorite: $imagesToFavorite,
                                                  imagesToUnfavorite: $imagesToUnfavorite)
                                    }
                                }
                            }
                        }
                        
                        HStack {
                            Button(action: saveProfile) {
                                Text("Salvar")
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                    .foregroundColor(.primaryColor)
                                    .background(Color.secondaryColor)
                                    .cornerRadius(20)
                            }
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }, label: {
                                Text("Cancelar")
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                    .foregroundColor(.secondaryColor)
                                    .background(colorScheme == .dark ? .black : .white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.secondaryColor, lineWidth: 2)
                                    )
                            })
                        }
                        .padding(.top, 20)
                    }
                    .padding(.top, 10)
                    .padding()
                }
            }
            
            Spacer()
            
        }
        .onAppear(perform: setCompositionalLayout)
        // Foto da galeria
        .sheet(isPresented: $showImagePicker, onDismiss: {
            showImagePicker = false
            activeSheet = nil
        }, content: {
            if activeSheet == .profile {
                ImagePicker(isShown: $showImagePicker, uiImage: $profileImage, sourceType: $sourceType)
            } else {
                ImagePicker(isShown: $showImagePicker, uiImage: $image, sourceType: $sourceType)
            }
        })
        .actionSheet(isPresented: $showImageAction) {
            sheet
        }
        // Feedback para o usuário
        .toast(isPresenting: $showSuccess, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: self.success)
        }, completion: {
            self.presentationMode.wrappedValue.dismiss()
        })
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red),
                       title: "Perfil não atualizado.",
                       subTitle: self.error)
        })
    }
}

extension Optional where Wrapped == String {
    var _bound: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bound: String {
        get {
            return _bound ?? ""
        }
        set {
            _bound = newValue.isEmpty ? nil : newValue
        }
    }
}

enum ActiveSheet {
   case profile, gallery
   var id: Int {
      hashValue
   }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(profile: Profile(
            id: "1",
            uid: "1",
            email: "wamarra@gmail.com",
            name: "Wesley Marra",
            phone: "61 98283-3810",
            statusMessage: "Olá meus amigos, bora tomar uma cerveja?", photoURL: URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2Fjv2EdvPcJhRwUc8c2l4485AP9113.jpg?alt=media&token=ca10d287-e258-412b-9bb8-26f4b6316bcb")))
            .preferredColorScheme(.dark)
    }
}
