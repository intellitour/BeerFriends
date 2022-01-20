//
//  ForgotPassawordView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 01/12/21.
//

import SwiftUI
import AlertToast

struct ForgotPassawordView: View {
    @State var email: String = ""
    @Namespace var animation
    @State var loading = false
    @State var error = false
    @State var success = false
    @Binding var animate3d: Bool
    
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @Environment(\.colorScheme) var colorScheme
    
    func forgotPassaword () {
        loading = true
        error = false
        userSessionStoreViewModel.forgotPassaword(email: email) { error in
            self.loading = false
            if error != nil {
                self.error = true
            } else {
                self.email = ""
                self.success = true
            }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Recuperar senha")
                .font(.custom(K.Fonts.GillSans, size: 25))
                .fontWeight(.bold)
                .foregroundColor(.secondaryColor)
            
            Text("Entre com seu e-mail cadastrado")
                .foregroundColor(.secondaryColor).opacity(0.5)
                .font(.custom(K.Fonts.GillSans, size: 18))
            
            Spacer(minLength: 5)
                        
            CustomTextField(image: K.Icon.Email, title: "E-mail", value: $email, animation: animation)
                    .autocapitalization(.none)
                                              
            Spacer(minLength: 5)
                      
            Button(action: forgotPassaword) {
                Text("Recuperar")
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
        .padding()
        .background(colorScheme == .dark ? .black : .white)
        .cornerRadius(20)
        .padding()        
        .toast(isPresenting: $error, alert: {
            AlertToast(type: .error(.red),
                       title: "Operação não realizada.",
                       subTitle: "Por favor, verifique o e-mail e tente novamente")
        })
        .toast(isPresenting: $success, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: "E-mail enviado com sucesso")
        }, completion: {
            withAnimation(Animation.linear(duration: 0.4)) {
                self.animate3d.toggle()
            }
        })
    }
}
