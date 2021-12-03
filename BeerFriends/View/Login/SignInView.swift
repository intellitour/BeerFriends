//
//  SignInView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/11/21.
//

import SwiftUI
import Lottie
import AlertToast

struct SignInView : View {

    @State var email: String = ""
    @State var password: String = ""
    @Namespace var animation
    
    @State var loading = false
    @State var error = false
    @State var isPresenting = false
    
    @Binding var show: Bool
    @Binding var showPackBeerImage: Bool
    @Binding var animateForgotPassaword: Bool
    @Binding var animateSignUp: Bool

    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel

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
        VStack(alignment: .leading, spacing: 6) {
            Text("Login")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.secondaryColor)
            
            Text("Entre com seus dados de acesso")
                .foregroundColor(.secondaryColor).opacity(0.5)
            
            Spacer(minLength: 5)
            
            
            CustomTextField(image: K.Icon.Envelope, title: "E-mail", value: $email, animation: animation)
                    .autocapitalization(.none)
            
            CustomTextField(image: K.Icon.Lock, title: "Senha", value: $password, animation: animation)
                    .autocapitalization(.none)
                                   
            
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
                    
                    Text("Ou")
                        .fontWeight(.bold)
                        .foregroundColor(.gray.opacity(0.5))
                    
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
        .background(.white)
        .cornerRadius(20)
        .padding()
        .frame(height: show ? nil : 0)
        .opacity(show ? 1 : 0)
        .toast(isPresenting: $error, alert: {
            AlertToast(type: .error(.red),
                       title: "Login não realizado.",
                       subTitle: "Por favor, verifique o e-mail ou a senha e tente novamente")
        })
    }
}
