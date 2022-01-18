//
//  ContextEventCardModifier.swift
//  BeerFriends
//
//  Created by Wesley Marra on 17/01/22.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContextEventCardModifier: ViewModifier {
    
    @State var cardURL: URL
    
    @Binding var eventImagesToRemove: [ProfileImages]
    
    func body(content: Content) -> some View {
        content
            .contextMenu(menuItems: {
                HStack {
                    Button(action: {
                        if !eventImagesToRemove.contains(where: {$0.imageURL == cardURL}) {
                            eventImagesToRemove.append(ProfileImages(imageURL: cardURL))
                        }
                    }) {
                        Label("Remover", systemImage: K.Icon.Remove)
                    }
                    .foregroundColor(.gray)
                }
            })
            .contentShape(RoundedRectangle(cornerRadius: 5))
    }
}

