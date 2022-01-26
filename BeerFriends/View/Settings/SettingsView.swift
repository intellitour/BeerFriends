//
//  SettingsView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 15/01/22.
//

import SwiftUI
import AlertToast

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDarkMode = false

    @Environment(\.colorScheme)
    private var colorScheme
    
    @Environment(\.presentationMode) var mode: Binding<PresentationMode>
    
    @EnvironmentObject var userSessionStoreViewModel: UserSessionStoreViewModel
    @EnvironmentObject var profileViewModel: ProfileViewModel
    
    @State var error: String?
    @State var showError = false
    @State var settings: Settings
    
    func getProfile() {
        settings.isDarkMode = colorScheme == .dark
        if userSessionStoreViewModel.userSession?.uid != nil {
            profileViewModel.findProfile(by: userSessionStoreViewModel.userSession?.uid ?? "")
        }
    }
    
    func update() {
        profileViewModel.update(profileViewModel.profile) { completionHandler in
            if completionHandler.error != nil {
                self.error = completionHandler.error?.localizedDescription
                self.showError = true
            } else {
                self.isDarkMode = self.settings.isDarkMode
            }
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(
                    header: Text("Tema").font(.caption2).foregroundColor(.secondaryColor),
                    footer: Text("Ao selecionar o tema escuro, a aplicação irá ignorar o do sistema operacional").font(.caption2).foregroundColor(.secondaryColor)) {
                        Toggle(
                            isOn: $settings.isDarkMode,
                            label: {Text("Escuro").foregroundColor(.gray)})
                            .onChange(of: settings.isDarkMode) { isDarkMode in
                                profileViewModel.profile.isDarkMode = isDarkMode
                                self.isDarkMode = isDarkMode
                                update()
                            }
                    }
                Section(
                    header: Text("Usuário").font(.caption2).foregroundColor(.secondaryColor)) {
                        Toggle(
                            isOn: $settings.isBlockInvitation,
                            label: {Text("Bloquear convites de amizade").foregroundColor(.gray)})
                            .onChange(of: settings.isBlockInvitation) { isBlockInvitation in
                                profileViewModel.profile.isBlockInvitation = isBlockInvitation
                                update()
                            }
                        Toggle(
                            isOn: $settings.isShowPhone,
                            label: {Text("Mostrar telefone").foregroundColor(.gray)})
                            .onChange(of: settings.isShowPhone) { isShowPhone in
                                profileViewModel.profile.isShowPhone = isShowPhone
                                update()
                            }
                    }
            }
            .navigationBarHidden(true)
        }
        .navigationTitle("Configurações")
        .navigationBarTitleDisplayMode(.automatic)
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: K.Icon.ArrowLeft)
                .foregroundColor(.secondaryColor)
        })
        .onAppear(perform: getProfile)
        .ignoresSafeArea()
        .toast(isPresenting: $showError, alert: {
            AlertToast(type: .error(.red), title: "Erro ao salvar configuração.", subTitle: self.error)
        })
        .onChange(of: isDarkMode) { newValue in
            withAnimation {
                settings.isDarkMode = newValue
            }
        }
    }
}

extension Binding {
    public func unwrap<Wrapped>(
        default: Wrapped,
        shouldBeNil: @escaping (Wrapped) -> Bool = { _ in false}
    ) -> Binding<Wrapped> where Value == Wrapped? {
        return .init(
            get: { wrappedValue ?? `default` },
            set: { self.wrappedValue = shouldBeNil($0) ? nil : $0 }
        )
    }
}

//struct SettingsView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingsView()
//    }
//}
