//
//  SideMenuViewModel.swift.swift
//  BeerFriends
//
//  Created by Wesley Marra on 08/12/21.
//

import Foundation
import SwiftUI

enum SideMenuOptions: Int, CaseIterable {
    case configurations
    case profile
    case friends
    case terms
    case loggout
    
    var icon: String {
        switch self {
        case .configurations: return  K.Icon.gearshapeFill
        case .profile: return K.Icon.PersonFill
        case .friends: return K.Icon.Person2Fill
        case .terms: return K.Icon.DocText
        case .loggout: return K.Icon.signOut
        }
    }
    
    var description: String {
        switch self {
        case .configurations: return "Configurações"
        case .profile: return "Perfil"
        case .friends: return "Amigos"
        case .terms: return "Termos e condições"
        case .loggout: return "Sair"
        }
    }
}
