//
//  UserSessionStoreService.swift
//  BeerFriends
//
//  Created by Wesley Marra on 03/12/21.
//

import Foundation
import Firebase

class UserSessionStoreService: ObservableObject {

    func signUp(email: String,
                password: String,
                handler: @escaping AuthDataResultCallback) {
        Auth.auth().createUser(withEmail: email, password: password, completion: handler)
    }

    func signIn(email: String,
                password: String,
                handler: @escaping AuthDataResultCallback) {
        Auth.auth().signIn(withEmail: email, password: password, completion: handler)
    }
    
    func forgotPassaword(email: String,
                         handler: @escaping SendPasswordResetCallback) {
        Auth.auth().sendPasswordReset(withEmail: email, completion: handler)
    }

    func signOut () -> Bool {
        do {
            try Auth.auth().signOut()
            return true
        } catch {
            return false
        }
    }
}

