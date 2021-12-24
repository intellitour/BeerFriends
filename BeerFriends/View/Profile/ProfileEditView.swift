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
    @State private var image: UIImage? = nil
    @State private var showAction = false
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @State var profile: Profile
    @State var loading = false
    @State var success: String?
    @State var error: String?
    @State var showSuccess = false
    @State var showError = false
    
    
    @ObservedObject var viewModel = ProfileViewModel()
    
    var sheet: ActionSheet {
       ActionSheet(
           title: Text("Selecione uma imagem"),
           message: Text("Escolha na galeria ou tire uma foto"),
           buttons: [
               .default(Text("Tirar foto"), action: {
                   showAction = false
                   showImagePicker = true
                   sourceType = .camera
               }),
               .cancel(Text("Cancelar"), action: {
                   showAction = false
               }),
               .default(Text("Escolher na geleria"), action: {
                   showAction = false
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
                       and: image) { ( completionHandler ) in
            
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
        return Image(systemName: K.Icon.plus)
            .foregroundColor(.primaryColor)
            .frame(width: 30, height: 30)
            .background(Color.secondaryColor)
            .clipShape(Circle())
            .padding(padding)
            .overlay(Circle().stroke(Color.primaryColor, lineWidth: lineWidth))
            .onTapGesture {
                 showAction = true
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
                            .foregroundColor(.secondaryColor)
                            .frame(width: 25, height: 25)
                    })
                    .padding(.bottom, 20)
                    .padding(.leading, 20)
                    
                    Spacer()
                }
                
                ZStack(alignment: .bottomTrailing) {
                    if self.image != nil {
                        Image(uiImage: self.image!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 200, height: 200)
                            .clipped()
                            .cornerRadius(150)
                            .shadow(radius: 2)
                            .onTapGesture {
                                showAction = true
                            }
                        
                        createImagePlus(with: 12, and: 0)
                        
                    } else if profile.photoURL != nil {
                        AsyncImage(
                            url: profile.photoURL,
                            content: { image in
                                image.resizable()
                                    .scaledToFill()
                                    .frame(width: 200, height: 200)
                                    .clipped()
                                    .cornerRadius(150)
                                    .shadow(radius: 2)
                                    .onTapGesture {
                                        showAction = true
                                    }
                                
                                createImagePlus(with: 12, and: 0)
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
                                showAction = true
                            }
                        
                        createImagePlus(with: 0, and: 3)
                    }
                }
                
                Text(profile.name ?? "")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryColor)
                
                Text(profile.email ?? "")
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.primaryColor)
            
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
                        CustomTextField(image: K.Icon.phone, title: "Telefone", value: $profile.phone.bound, animation: animation)
                            .keyboardType(.phonePad)
                        
                        ZStack {
                            HStack(alignment: .top) {
                                Image(systemName: K.Icon.statusMessage)
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
                        
                        HStack {
                            Button(action: saveProfile) {
                                Text("Cadastrar")
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                    .foregroundColor(.primaryColor)
                                    .background(Color.secondaryColor)
                                    .cornerRadius(20)
                            }
                            
                            Button(action: {}, label: {
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
                    }
                    .padding(.top, 10)
                    .padding()
                }
            }
            
            Spacer()
            
        }
        .sheet(isPresented: $showImagePicker, onDismiss: {
            showImagePicker = false
        }, content: {
            ImagePicker(isShown: $showImagePicker, uiImage: $image, sourceType: $sourceType)
        })
        .actionSheet(isPresented: $showAction) {
            sheet
        }
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

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(profile: Profile())
    }
}
