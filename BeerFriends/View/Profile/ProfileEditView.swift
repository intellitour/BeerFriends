//
//  ProfileEditView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 13/12/21.
//

import SwiftUI
import AlertToast

struct ProfileEditView: View {
    
    @Namespace var animation
    @State private var profileImage: UIImage? = nil
    @State private var image: UIImage? = nil
    @State private var eventImage: UIImage? = nil
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
    @State var isFinished = false
    @State var compositionalCardsImage: [[URL]] = []
    
    @State var eventImagesToRemove: [ProfileImages] = []
    @State var imagesToRemove: [ProfileImages] = []
    @State var imagesToFavorite: [ProfileImages] = []
    @State var imagesToUnfavorite: [ProfileImages] = []
    
    @ObservedObject var viewModel = ProfileViewModel()
        
    var sheet: ActionSheet {
       ActionSheet(
           title: Text("Selecione uma imagem"),
           message: Text(UIImagePickerController.isSourceTypeAvailable(.camera) ? "Escolha na galeria ou tire uma foto" : "Escolha na galeria"),
           buttons: getButtons())
    }
    
    func getButtons() -> [ActionSheet.Button] {
        var actions: [ActionSheet.Button] = []
        
        actions.append(contentsOf: [
            .cancel(Text("Cancelar"), action: {
                showImageAction = false
            }),
            .default(Text("Escolher na geleria"), action: {
                showImageAction = false
                showImagePicker = true
                sourceType = .photoLibrary
            })
        ])
        
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            actions.append(.default(Text("Tirar foto"), action: {
                showImageAction = false
                showImagePicker = true
                sourceType = .camera
            }))
        }
        
        return actions
    }
    
    func saveProfile() {
        self.loading = true
        self.showError = false
        self.showSuccess = false
        
        let flatMappedCardsImage = compositionalCardsImage.flatMap({ (element: [URL]) -> [URL] in
            return element
        })
                
        viewModel.save(
            with: Profile(id: profile.id,
                          uid: profile.uid,
                          email: profile.email,
                          name: profile.name,
                          phone: profile.phone,
                          statusMessage: profile.statusMessage,
                          photoURL: profile.photoURL,
                          galleryImagesURL: flatMappedCardsImage,
                          eventImagesURL: profile.eventImagesURL),
            and: profileImage,
            and: imagesToRemove,
            and: imagesToFavorite,
            and: imagesToUnfavorite,
            and: eventImagesToRemove) { ( completionHandler ) in
            
            loading = false
            
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.success = completionHandler.success
                self.showSuccess = true
                self.isFinished = true
            }
        }
    }
    
    func addImagesToEventsGallery() {
        if image != nil {
            self.loading = true
            self.showError = false
            self.showSuccess = false
            
            viewModel.addImagesToEventsGallery(
                from: profile.uid!,
                with: image!) { ( completionHandler ) in
                    
                    if completionHandler.error != nil {
                        self.error = completionHandler.error?.localizedDescription
                        self.showError = true
                    } else {
                        self.success = completionHandler.success
                        self.showSuccess = true
                        var flatMappedCardsImage = compositionalCardsImage.flatMap({ (element: [URL]) -> [URL] in
                            return element
                        })
                        flatMappedCardsImage.append(completionHandler.data!)
                        self.setCompositionalLayout(with: flatMappedCardsImage)
                    }
                    
                    loading = false
                    image = nil
                }
        }
        
        if eventImage != nil {
            self.loading = true
            self.showError = false
            self.showSuccess = false
            
            viewModel.addImagesToEventsGallery(
                from: profile.uid!,
                with: eventImage!) { ( completionHandler ) in
                    
                    if completionHandler.error != nil {
                        self.error = completionHandler.error?.localizedDescription
                        self.showError = true
                    } else {
                        self.success = completionHandler.success
                        self.showSuccess = true
                        if self.profile.eventImagesURL == nil {
                            self.profile.eventImagesURL = []
                        }
                        self.profile.eventImagesURL?.append(completionHandler.data!)
                    }
                    
                    loading = false
                    eventImage = nil
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
    
    func setCompositionalLayout(with imagesUrl: [URL]?) {
        self.compositionalCardsImage = []
        var currentArrayCards: [URL] = []
        
       imagesUrl?.forEach { (url) in
            currentArrayCards.append(url)
            
            if currentArrayCards.count == 3 {
                self.compositionalCardsImage.append(currentArrayCards)
                currentArrayCards.removeAll()
            }
            
           if currentArrayCards.count != 3 && url == imagesUrl?.last {
               self.compositionalCardsImage.append(currentArrayCards)
                currentArrayCards.removeAll()
            }
        }
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
                    
                    Text("Você ainda não adicionou eventos")
                        .font(.title2.bold())
                        .foregroundColor(.secondaryColor)
                        .multilineTextAlignment(.center)
                        .padding()
                }
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 50) {
                        ForEach(urls, id: \.self) { url in
                            GeometryReader { proxy in
                                let scale = getScale(proxy: proxy)
                                
                                let context = ContextEventCardModifier(
                                    cardURL: url,
                                    eventImagesToRemove: $eventImagesToRemove
                                )
                                
                                let isRemoved = eventImagesToRemove.filter(){ $0.imageURL == url }.count > 0
                                
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
                                                .modifier(context)
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    },
                                    placeholder: {
                                        ProgressView()
                                            .frame(width: scale, height: scale, alignment: .center)
                                    })
                                    .opacity(isRemoved ? 0.5 : 1)
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
                        Image(systemName: K.Icon.CircleUser)
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
                    .font(.custom(K.Fonts.GillSans, size: 22))
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryColor)
                
                Text(profile.email ?? "")
                    .foregroundColor(.black.opacity(0.5))
                    .font(.custom(K.Fonts.GillSans, size: 16))
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
                        CustomTextField(image: K.Icon.User, title: "Nome", value: $profile.name.bound, animation: animation)
                            .textInputAutocapitalization(.words)
                        CustomTextField(image: K.Icon.Email, title: "E-mail", value: $profile.email.bound, animation: animation)
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
                                    .font(.custom(K.Fonts.GillSans, size: 25))
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondaryColor)
                                    .padding(.top, 20)
                                    .padding(.bottom, -1)
                                
                                Spacer()
                                
                                Button(action: addImagesToEventsGallery) {
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
                                }
                            }
                            
                            Divider()
                            
                            if !compositionalCardsImage.isEmpty {
                                VStack(spacing: 4) {
                                    ForEach(compositionalCardsImage.indices, id: \.self) {index in
                                        if !compositionalCardsImage[index].isEmpty {
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
                            } else {
                                ZStack {
                                    Image("GalleryImages")
                                        .resizable()
                                        .frame(width: UIScreen.main.bounds.width - 40, height: 300)
                                        .opacity(0.2)
                                    
                                    Text("Você ainda não adicionou imagens!")
                                        .font(.title2.bold())
                                        .foregroundColor(.secondaryColor)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            
                            HStack {
                                Text("Próximos eventos")
                                    .font(.custom(K.Fonts.GillSans, size: 25))
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondaryColor)
                                    .padding(.top, 20)
                                    .padding(.bottom, -1)
                                
                                Spacer()
                                
                                Button(action: addImagesToEventsGallery) {
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
                                            activeSheet = .event
                                        }
                                }
                            }
                            .padding(.top, 30)
                            
                            Divider()
                            
                            ZStack {
                                getGalleryImages(urls: profile.eventImagesURL ?? [])
                            }
                            .frame(height: UIScreen.main.bounds.height / (profile.eventImagesURL == nil ? 2.2 : 1.6))
                            .padding(.top, 20)
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
        .onAppear(perform: {
            setCompositionalLayout(with: profile.galleryImagesURL)
            profile.favoriteImagesURL?.forEach({ favoriteUrl in
                imagesToFavorite.append(ProfileImages(imageURL: favoriteUrl))
            })
        })
        // Foto da galeria
        .sheet(isPresented: $showImagePicker, onDismiss: {
            showImagePicker = false
            activeSheet = nil
            addImagesToEventsGallery()
        }, content: {
            if activeSheet == .profile {
                ImagePicker(isShown: $showImagePicker, uiImage: $profileImage, sourceType: $sourceType)
            } else if activeSheet == .gallery {
                ImagePicker(isShown: $showImagePicker, uiImage: $image, sourceType: $sourceType)
            } else {
                ImagePicker(isShown: $showImagePicker, uiImage: $eventImage, sourceType: $sourceType)
            }
        })
        .actionSheet(isPresented: $showImageAction) {
            sheet
        }
        // Feedback para o usuário
        .toast(isPresenting: $showSuccess, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: self.success)
        }, completion: {
            if isFinished {
                self.presentationMode.wrappedValue.dismiss()
            }
        })
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red),
                       title: "Erro ao salvar.",
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
   case profile, gallery, event
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
