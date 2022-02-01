//
//  SignInView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/11/21.
//

import SwiftUI
import Lottie
import AlertToast

fileprivate enum FocusedField {
    case email
    case password
}

struct SignInView : View {

    @State var email: String = ""
    @State var password: String = ""
    @Namespace var animation
    
    @State var loading = false
    @State var error = false
    @State var isPresenting = false
    
    @Binding var showCard: Bool
    @Binding var showPackBeerImage: Bool
    @Binding var animateForgotPassaword: Bool
    @Binding var animateSignUp: Bool

    @FocusState private var activeTextField: FocusedField?

    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @Environment(\.colorScheme) var colorScheme

    func signIn () {
        loading = true
        error = false
        userSessionStoreViewModel.signIn(email: email, password: password) { (result, error) in
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
                Text("Login")
                    .font(.custom(K.Fonts.GillSans, size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryColor)
                
                Text("Entre com seus dados de acesso")
                    .foregroundColor(.secondaryColor).opacity(0.5)
                    .font(.custom(K.Fonts.GillSans, size: 18))
                
                Spacer(minLength: 5)


                CustomTextField(image: K.Icon.Email, title: "E-mail", value: $email, animation: animation)
                    .autocapitalization(.none)
                    .keyboardType(.emailAddress)
                    .submitLabel(.next)
                    .focused($activeTextField, equals: .email)
                    .onSubmit {
                        activeTextField = .password
                    }

                
                CustomTextField(image: K.Icon.Password, title: "Senha", value: $password, animation: animation)
                    .autocapitalization(.none)
                    .focused($activeTextField, equals: .password)
                    .submitLabel(.send)
                
                
                Text("Esqueci a senha")
                    .font(.subheadline)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .foregroundColor(.secondaryColor)
                    .onTapGesture {
                        withAnimation(Animation.linear(duration: 0.4)) {
                            self.animateForgotPassaword.toggle()
                        }
                    }
                
                Spacer(minLength: 5)
                
                VStack {
                    Button(action: signIn) {
                        Text("Entrar")
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                            .foregroundColor(.secondaryColor)
                            .background(Color.primaryColor)
                            .cornerRadius(20)
                    }
                    
                    HStack {
                        Rectangle()
                            .fill(.gray.opacity(0.5))
                            .frame(height: 1)
                        
                        Text("~ ou ~")
                            .fontWeight(.bold)
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.custom(K.Fonts.GillSans, size: 12))
                        
                        Rectangle()
                            .fill(.gray.opacity(0.5))
                            .frame(height: 1)
                    }.padding(.vertical, 2)
                    
                    Button(action: {
                        withAnimation(Animation.linear(duration: 0.4)) {
                            self.animateSignUp.toggle()
                        }
                    }) {
                        Text("Cadastrar")
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                            .foregroundColor(.primaryColor)
                            .background(Color.secondaryColor)
                            .cornerRadius(20)
                    }
                }
            }
            .padding()
            .background(colorScheme == .dark ? .black : .white)
            .cornerRadius(20)
            .padding()
            .frame(height: showCard ? nil : 0)
            .opacity(showCard ? 1 : 0)
            .toast(isPresenting: $error, alert: {
                AlertToast(type: .error(.red),
                           title: "Login não realizado.",
                           subTitle: "Por favor, verifique o e-mail ou a senha e tente novamente")
            })
        }
    }
}
