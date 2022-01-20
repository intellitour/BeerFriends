//
//  ContextCardModifier.swift
//  BeerFriends
//
//  Created by Wesley Marra on 24/12/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct ContextCardModifier: ViewModifier {
       
    @State var cardURL: URL
    
    @Binding var isFavorite: Bool
    @Binding var imagesToRemove: [ProfileImages]
    @Binding var imagesToFavorite: [ProfileImages]
    @Binding var imagesToUnfavorite: [ProfileImages]
    
    func body(content: Content) -> some View {
        content
            .contextMenu(menuItems: {
                HStack {
                    Button(action: {
                        isFavorite.toggle()
                        if isFavorite {
                            if !imagesToFavorite.contains(where: {$0.imageURL == cardURL}) {
                                imagesToFavorite.append(ProfileImages(imageURL: cardURL))
                            }
                            imagesToUnfavorite = imagesToUnfavorite.filter(){ $0.imageURL != cardURL && $0.uid == nil }
                        } else {
                            if !imagesToUnfavorite.contains(where: {$0.imageURL == cardURL}) {
                                imagesToUnfavorite.append(ProfileImages(imageURL: cardURL))
                            }
                            imagesToFavorite = imagesToFavorite.filter(){ $0.imageURL != cardURL && $0.uid == nil }
                        }
                    }) {
                        Label(isFavorite ? "Desfavoritar" : "Favoritar",
                              systemImage: isFavorite ? K.Icon.Unfavorite : K.Icon.Favorite)
                    }
                    
                    Button(role: .destructive, action: {
                        if !imagesToRemove.contains(where: {$0.imageURL == cardURL}) {
                            imagesToRemove.append(ProfileImages(imageURL: cardURL))
                            imagesToFavorite = imagesToFavorite.filter(){ $0.imageURL != cardURL }
                            imagesToUnfavorite = imagesToUnfavorite.filter(){ $0.imageURL != cardURL }
                        }
                    }) {
                        Label("Remover", systemImage: K.Icon.Remove)
                    }
                }
            })
            .contentShape(RoundedRectangle(cornerRadius: 5))
    }
}

