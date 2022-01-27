//
//  AbusiveContentView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 26/01/22.
//

import SwiftUI
import AlertToast

struct AbusiveContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    @Namespace var animation
    @State var reason: String = ""
    @State var description: String = ""
    @State var reporter: Profile
    @State var denounced: Profile
    @State var showSuccess = false
    @State var showError = false
    @State var showValidationError = false
    @State var validationMessage: String = ""
    
    @ObservedObject var friendProfileViewModel = FriendProfileViewModel()
    
    func denounce() {
        if reason.isEmpty {
            showValidationError = true
            validationMessage = "O campo Motivo é obrigatório"
            return
        }
        
        if description.isEmpty {
            showValidationError = true
            validationMessage = "O campo Descrição é obrigatório"
            return
        }
        
        friendProfileViewModel.denounce(with: reason,
                                        and: description,
                                        and: reporter,
                                        and: denounced) { (completionHandler) in
            if completionHandler.error != nil {
                showError = true
            } else {
                showSuccess = true
            }
        }
    }
    
    var body: some View {
        VStack {
            VStack {
                ZStack {
                    LinearGradient(gradient: Gradient(colors: [Color.secondaryColor, Color.primaryColor]),
                                   startPoint: .top,
                                   endPoint: .bottom
                    )
                    
                    HStack {
                        Image(K.System.Icon)
                            .resizable()
                            .foregroundColor(.primaryColor)
                            .frame(width: 30, height: 30)
                            .padding(8.5)
                            .background(Color.primaryColor)
                            .cornerRadius(30)
                        VStack {
                            Text("Beer Friends")
                                .foregroundColor(.primaryColor)
                                .fontWeight(.bold)
                                .font(.custom(K.Fonts.Papyrus, size: 30))
                                .padding(.bottom, -10)
                            Text("O lugar dos amigos")
                                .foregroundColor(.secondaryColor)
                                .font(.custom(K.Fonts.Papyrus, size: 14))
                                .padding(.top, -10)
                                .padding(.leading, 45)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
            .frame(height: UIScreen.main.bounds.height / 5, alignment: .top)
            
            Text("Denunciar")
                .foregroundColor(.secondaryColor)
                .font(.custom(K.Fonts.GillSans, size: 30))
                .fontWeight(.semibold)
                .padding(.top, 20)
            Text("Conteúdo abusivo")
                .foregroundColor(.secondaryColor)
                .font(.custom(K.Fonts.GillSans, size: 30))
                .fontWeight(.semibold)
                .padding(.top, -20)
            
            VStack {
                CustomTextField(image: K.Icon.AbusiveContent, title: "Motivo", value: $reason, animation: animation)
                    .textInputAutocapitalization(.words)
                    .padding(.horizontal, 10)
                
                ZStack {
                    HStack(alignment: .top) {
                        Image(systemName: K.Icon.StatusMessage)
                            .font(.system(size: 22))
                            .foregroundColor(.secondaryColor)
                            .frame(width: 35)
                            .padding(.top, 8)
                      
                        ZStack(alignment: Alignment(horizontal: .leading, vertical: .top)) {
                            if description == "" {
                                Text("Descrição")
                                    .font(.caption)
                                    .fontWeight(.heavy)
                                    .opacity(0.6)
                                    .padding(.top, 10)
                            }
                            TextEditor(text: $description)
                                .frame(width: UIScreen.main.bounds.width - 100)
                                .textInputAutocapitalization(.sentences)
                                .opacity(description == "" ? 0.2 : 1)
                        }
                    }
                }
                
                Spacer()
                Divider()
                    .padding(.horizontal, 10)
            }
            .padding()
            
            Spacer()
            
            HStack() {
                Button(action: denounce) {
                    Text("Denunciar")
                        .frame(minWidth: 100, maxWidth: .infinity, minHeight: 35, maxHeight: 35, alignment: .center)
                        .foregroundColor(.primaryColor)
                        .background(Color.secondaryColor)
                        .cornerRadius(20)
                }
                
                Button(action: {
                    withAnimation(.spring()) {
                        presentationMode.wrappedValue.dismiss()
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
        }
        .toast(isPresenting: $showSuccess, alert: {
            AlertToast(displayMode: .alert, type: .complete(.green), title: "Denúncia registrada com sucesso")
        }, completion: {
            presentationMode.wrappedValue.dismiss()
        })
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red), title: "Erro", subTitle: "Erro ao tentar registrar a denúncia")
        })
        .toast(isPresenting: $showValidationError, alert: {
            AlertToast(type: .error(.red), title: "Erro", subTitle: validationMessage)
        })
    }
}

struct AbusiveContentView_Previews: PreviewProvider {
    static var previews: some View {
        AbusiveContentView(reporter: Profile(), denounced: Profile())
    }
}
