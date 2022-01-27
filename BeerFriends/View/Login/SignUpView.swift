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
    @State var loading = false
    @State var error = false
    @State var validationError = false
    @State var validationMessage = ""
    @State var name: String = ""
    @State var email: String = ""
    @State var password: String = ""
    @State var privacyPolicyAndTerms = false
    
    @Namespace var animation
    @Binding var animate3d: Bool

    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @Environment(\.colorScheme) var colorScheme

    func signUp () {
        if name.isEmpty {
            validationError = true
            validationMessage = "O Nome é obrigatorio"
            return
        }
        if email.isEmpty {
            validationError = true
            validationMessage = "O E-mail é obrigatorio"
            return
        }
        if password.isEmpty {
            validationError = true
            validationMessage = "A Senha é obrigatoria"
            return
        }
        if !privacyPolicyAndTerms {
            validationError = true
            validationMessage = "Política de privacidade e termos de uso não selecionado"
            return
        }
        
        loading = true
        error = false
        
        userSessionStoreViewModel.signUp(name: name, email: email, password: password, privacyPolicyAndTerms: privacyPolicyAndTerms) { (result, error) in
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
                    .font(.custom(K.Fonts.GillSans, size: 25))
                    .fontWeight(.bold)
                    .foregroundColor(.secondaryColor)
                
                Text("Informe o e-mail e senha para continuar")
                    .foregroundColor(.secondaryColor).opacity(0.5)
                    .font(.custom(K.Fonts.GillSans, size: 18))
                
                Spacer(minLength: 5)
                
                CustomTextField(image: K.Icon.CircleUser, title: "Nome", value: $name, animation: animation)
                        .autocapitalization(.none)
                
                CustomTextField(image: K.Icon.Email, title: "E-mail", value: $email, animation: animation)
                        .autocapitalization(.none)
                
                CustomTextField(image: K.Icon.Password, title: "Senha", value: $password, animation: animation)
                        .autocapitalization(.none)
                
                Toggle("Estou de acordo com a política de privacidade e termos de uso do Beer Friends", isOn: $privacyPolicyAndTerms)
                    .font(.custom(K.Fonts.GillSans, size: 12))
                    .foregroundColor(.gray)
                
                Spacer(minLength: 5)
                
                HStack() {
                    Button(action: signUp) {
                        Text("Salvar")
                            .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                            .foregroundColor(.secondaryColor)
                            .background(Color.primaryColor)
                            .cornerRadius(20)
                    }
                    
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
                
                HStack {
                    Spacer()
                    
                    Link("Política de privacidade", destination: URL(string: "https://wamarra.github.io/privacyPolicy.html")!)
                        .font(.custom(K.Fonts.GillSans, size: 12))
                    
                    Text(" | ")
                        .fontWeight(.bold)
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.custom(K.Fonts.GillSans, size: 12))
                    
                    Link("Termos de uso", destination: URL(string: "https://wamarra.github.io/termsOfUse.html")!)
                        .font(.custom(K.Fonts.GillSans, size: 12))
            
                    Spacer()
                }
                .padding(.top)
            }
            .padding()
            .background(colorScheme == .dark ? .black : .white)
            .cornerRadius(20)
            .padding()
            .toast(isPresenting: $error, alert: {
                AlertToast(type: .error(.red),
                           title: "Erro no cadastros",
                           subTitle: "Por favor, verifique o e-mail ou a senha e tente novamente")
            })
            .toast(isPresenting: $validationError, alert: {
                AlertToast(type: .error(.red),
                           title: "Erro",
                           subTitle: validationMessage)
            })
        }
    }
}

struct SignUPView_Previews: PreviewProvider {
    static var previews: some View {
        SignUPView(animate3d: .constant(true))
    }
}
