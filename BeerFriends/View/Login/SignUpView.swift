//
//  SignUPView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 01/12/21.
//

import SwiftUI
import Lottie
import AlertToast

struct SignUPView: View {
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @Namespace var animation
    
    @Binding var animate3d: Bool
    
    @State var loading = false
    @State var error = false

    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @Environment(\.colorScheme) var colorScheme

    func signUp () {
        loading = true
        error = false
        userSessionStoreViewModel.signUp(name: name, email: email, password: password) { (result, error) in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.password = ""
            }
        }
    }

    var body: some View {
        if loading {
            AlertToast(type: .loading)
        } else {
            VStack(alignment: .leading, spacing: 6) {
                Text("Cadastro")
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryColor)
                
                Text("Informe o e-mail e senha para continuar")
                    .foregroundColor(.secondaryColor).opacity(0.5)
                
                Spacer(minLength: 5)
                
                CustomTextField(image: K.Icon.CircleUser, title: "Nome", value: $name, animation: animation)
                        .autocapitalization(.none)
                
                CustomTextField(image: K.Icon.Email, title: "E-mail", value: $email, animation: animation)
                        .autocapitalization(.none)
                
                CustomTextField(image: K.Icon.Password, title: "Senha", value: $password, animation: animation)
                        .autocapitalization(.none)
                
                Spacer(minLength: 5)
                
                VStack() {
                    Button(action: signUp) {
                        Text("Salvar")
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                            .foregroundColor(.secondaryColor)
                            .background(Color.primaryColor)
                            .cornerRadius(20)
                    }
                    .padding(.bottom)
                    
                    Button(action: {
                        withAnimation(Animation.linear(duration: 0.4)) {
                            self.animate3d.toggle()
                        }
                    }) {
                        Text("Cancelar")
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                            .foregroundColor(.secondaryColor)
                            .background(colorScheme == .dark ? .black : .white)
                            .overlay(
                                RoundedRectangle(cornerRadius: 20)
                                    .stroke(Color.secondaryColor, lineWidth: 2)
                            )
                    }
                }
            }
            .padding()
            .background(colorScheme == .dark ? .black : .white)
            .cornerRadius(20)
            .padding()
            .toast(isPresenting: $error, alert: {
                AlertToast(type: .error(.red),
                           title: "Erro no cadastro.",
                           subTitle: "Por favor, verifique o e-mail ou a senha e tente novamente")
            })
        }
    }
}
