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
    @State var loading = false
    @State var error = false
    @State var show = false
    @State var showPackBeerImage = false
    @State var isPresenting = false

    @EnvironmentObject var sessionStore: SessionStore

    func signIn () {
        loading = true
        error = false
        sessionStore.signIn(email: email, password: password) { (result, error) in
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
                        Image(K.Login.SignInImage)
                            .frame(width: UIScreen.main.bounds.width, alignment: .top)
                    }
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Login")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.secondaryColor)
                        
                        Text("Entre com seus dados de acesso")
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
                        
                        Text("Esqueci a senha")
                            .font(.subheadline)
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(.secondaryColor)
                            .onTapGesture {
                                print("Chamar popup de esqueci a senha")
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
                                    .fill(Color.secondaryColor.opacity(0.3))
                                    .frame(height: 1)
                                
                                Text("Ou")
                                    .fontWeight(.bold)
                                    .foregroundColor(.secondaryColor.opacity(0.3))
                                
                                Rectangle()
                                    .fill(Color.secondaryColor.opacity(0.3))
                                    .frame(height: 1)
                            }.padding(.vertical, 2)
                            
                            Button(action: {
                                isPresenting.toggle()
                            }) {
                                Text("Cadastrar")
                                    .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                                    .foregroundColor(.primaryColor)
                                    .background(Color.secondaryColor)
                                    .cornerRadius(20)
                            }
                            .fullScreenCover(isPresented: $isPresenting) {
                                SignUPView()
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
                       title: "Login não realizado.",
                       subTitle: "Por favor, verifique o e-mail ou a senha e tente novamente")
        })
    }
}
