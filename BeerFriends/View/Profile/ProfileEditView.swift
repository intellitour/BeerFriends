//
//  ProfileEditView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 13/12/21.
//

import SwiftUI

struct ProfileEditView: View {
    @Namespace var animation
    @State var id: String
    @State var uid: String
    @State var name: String
    @State var email: String
    @State var phone: String
    @State var statusMessage: String
    
    @ObservedObject var viewModel = ProfileViewModel()
    
    init(profile: Profile) {
        self.id = profile.id
        self.uid = profile.uid ?? ""
        self.name = profile.name ?? ""
        self.email = profile.email ?? ""
        self.phone = profile.phone ?? ""
        self.statusMessage = profile.statusMessage ?? ""
    }
        
    var body: some View {
        VStack {
            VStack {
                Image("image14")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 200, height: 200)
                    .clipped()
                    .cornerRadius(150)
                    .shadow(radius: 3)
                    .overlay(
                        Circle().stroke(Color.secondaryColor, lineWidth: 2)
                    )
                
                Text(name)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryColor)
                
                Text(email)
                    .foregroundColor(.gray)
            }
            .padding(.top, 20)
            .padding(.bottom, 30)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.primaryColor)
            
            ScrollView {
                VStack {
                    CustomTextField(image: K.Icon.PersonFill, title: "Nome", value: $name, animation: animation)
                    CustomTextField(image: K.Icon.Envelope, title: "E-mail", value: $email, animation: animation)
                        .keyboardType(.emailAddress)
                    CustomTextField(image: K.Icon.phone, title: "Telefone", value: $phone, animation: animation)
                        .keyboardType(.phonePad)
                    
                    ZStack {
                        HStack(alignment: .top) {
                            Image(systemName: K.Icon.statusMessage)
                                .font(.system(size: 22))
                                .foregroundColor(.secondaryColor)
                                .frame(width: 35)
                                .padding(.top, 10)
                            
                            TextEditor(text: $statusMessage)
                                .frame(width: UIScreen.main.bounds.width - 100)
                            Text(statusMessage).opacity(0).padding(.all, 8)
                        }
                    }
                    .frame(height: 150)
                    Divider()
                    
                    HStack {
                        Button(action: {}, label: {
                            Text("Cadastrar")
                                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                .foregroundColor(.primaryColor)
                                .background(Color.secondaryColor)
                                .cornerRadius(20)
                        })
                        
                        Button(action: {}, label: {
                            Text("Cancelar")
                                .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                .foregroundColor(.secondaryColor)
                                .background(.white)
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
            
            Spacer()
            
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(profile: Profile())
    }
}
