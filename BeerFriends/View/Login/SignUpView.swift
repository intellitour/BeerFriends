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
    @State var email: String = ""
    @State var password: String = ""
    @State var loading = false
    @State var error = false
    @State var show = false
    @State var showPackBeerImage = false

    @EnvironmentObject var sessionStore: SessionStore
    @Environment(\.presentationMode) var presentationMode

    func signUp () {
        loading = true
        error = false
        sessionStore.signUp(email: email, password: password) { (result, error) in
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
        VStack {
            ZStack {
                Color(uiColor: UIColor(.primaryColor)).ignoresSafeArea()
                VStack {
                    if !showPackBeerImage {
                        AnimatedView(show: $show, showPackBeerImage: $showPackBeerImage)
                            .frame(height: UIScreen.main.bounds.height / 2.5)
                    } else {
                        Image(K.Login.SignUpImage)
                            .frame(width: UIScreen.main.bounds.width, alignment: .top)
                    }
                                            
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Cadastro")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondaryColor)
                        
                        Text("Informe o e-mail e senha para continuar")
                            .foregroundColor(.secondaryColor).opacity(0.5)
                        
                        Spacer(minLength: 5)
                        
                        VStack {
                            TextField("E-mail", text: $email, prompt: Text("E-mail"))
                                .autocapitalization(.none)
                            
                            Divider()
                                .background(Color(UIColor(.gray)))
                            
                            SecureField("Senha", text: $password, prompt: Text("Senha"))
                            Divider()
                                .background(Color(UIColor(.gray)))
                        }
                        
                        Spacer(minLength: 5)
                        
                        VStack {
                            Button(action: signUp) {
                                Text("Cadastrar")
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                    .foregroundColor(.secondaryColor)
                                    .background(Color.primaryColor)
                                    .cornerRadius(20)
                            }
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Cancelar")
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                    .foregroundColor(.secondaryColor)
                                    .background(.white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(Color.secondaryColor, lineWidth: 2)
                                    )
                            }
                        }
                    }
                    .padding()
                    .background(.white)
                    .cornerRadius(20)
                    .padding()
                    .frame(height: show ? nil : 0)
                    .opacity(show ? 1 : 0)
                }
            }
        }
        .toast(isPresenting: $error, alert: {
            AlertToast(type: .error(.red),
                       title: "Erro no cadastro.",
                       subTitle: "Por favor, verifique o e-mail ou a senha e tente novamente")
        })
    }
}

struct SignUPView_Previews: PreviewProvider {
    static var previews: some View {
        SignUPView()
    }
}
