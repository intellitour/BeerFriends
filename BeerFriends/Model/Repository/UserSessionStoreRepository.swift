//
//  UserSessionStoreService.swift
//  BeerFriends
//
//  Created by Wesley Marra on 03/12/21.
//

import Foundation
import Firebase

class UserSessionStoreRepository {

    func signUp(name: String,
                email: String,
                password: String,
                privacyPolicyAndTerms: Bool,
                handler: @escaping AuthDataResultCallback) {
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if error != nil  {
                handler(nil, error)
            }
            
            guard let user = result?.user else { return }
            
            var searchTerms: [String] = [];
            let separatedNames = name.split(separator: " ")
            separatedNames.forEach { name in
                var term = ""
                name.forEach { letter in
                    term += letter.lowercased()
                    searchTerms.append(term)
                }
            }
            
            let profile = Profile(uid: user.uid,
                                  email: user.email,
                                  name: name,
                                  phone: user.phoneNumber,
                                  photoURL: user.photoURL,
                                  searchTerms: searchTerms,
                                  privacyPolicyAndTerms: privacyPolicyAndTerms)

            ProfileRepository().createProfile(profile: profile)
        }
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

