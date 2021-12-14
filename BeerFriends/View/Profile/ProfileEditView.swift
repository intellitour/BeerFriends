//
//  ProfileEditView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 13/12/21.
//

import SwiftUI

struct ProfileEditView: View {
    @Namespace var animation
    @State var name: String
    @State var email: String
    @State var phone: String
    @State var statusMessage: String
    
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
            .padding(.top, 70)
            .padding(.bottom, 50)
            .frame(width: UIScreen.main.bounds.width)
            .background(Color.primaryColor)
            .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    CustomTextField(image: K.Icon.PersonFill, title: "Nome", value: $name, animation: animation)
                    CustomTextField(image: K.Icon.Envelope, title: "E-mail", value: $email, animation: animation)  .keyboardType(.emailAddress)
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
                    .padding(.vertical)
                }
                .padding(.top, -30)
            .padding()
            }
            
            Spacer()
            
        }
    }
}

struct ProfileEditView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditView(name: "Wesley Alberto Marra",
                        email: "wamarra@gmail.com",
                        phone: "61 98283-3810",
                        statusMessage: "Um grande adorador de cervejas artesanais com preferância nas do tipo IPA e Session IPA. E claro, ceveja sem amigos não é cerveja é solidão ;)")
    }
}
