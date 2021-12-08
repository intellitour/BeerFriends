//
//  SessionStore.swift
//  BeerFriends
//
//  Created by Wesley Marra on 29/11/21.
//

import SwiftUI
import Firebase
import Combine

class UserSessionStoreViewModel : ObservableObject {
    var didChange = PassthroughSubject<UserSessionStoreViewModel, Never>()
    var handle: AuthStateDidChangeListenerHandle?
    
    @ObservedObject
    private var userSessionStoreService = UserSessionStoreRepository()
    
    @Published
    var userSession: User? {
        didSet {
            self.didChange.send(self)
        }
    }

    func listen () {
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                print("Usuário obtido: \(user)")
                self.userSession = User(
                    uid: user.uid,
                    email: user.email,
                    displayName: user.displayName
                )
            }
        }
    }

    func signUp(name: String,
                email: String,
                password: String,
                handler: @escaping AuthDataResultCallback) {
        userSessionStoreService.signUp(name: name, email: email, password: password, handler: handler)
    }

    func signIn(email: String,
                password: String,
                handler: @escaping AuthDataResultCallback) {
        userSessionStoreService.signIn(email: email, password: password, handler: handler)
    }
    
    func forgotPassaword(email: String,
                         handler: @escaping SendPasswordResetCallback) {
        userSessionStoreService.forgotPassaword(email: email, handler: handler)
    }

    func signOut () -> Bool {
        let result = userSessionStoreService.signOut()
        if result {
            self.userSession = nil
        }
        return result
    }
    
    
    func unbind () {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
