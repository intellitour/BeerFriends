//
//  LayoutThree.swift
//  BeerFriends
//
//  Created by Wesley Marra on 24/12/21.
//

import SwiftUI

struct LayoutThree: View {
    @State var cards: [URL]
    
    @State var isFavoriteOne: Bool = false
    @State var isFavoriteTwo: Bool = false
    @State var isFavoriteThree: Bool = false
    
    @Binding var imagesToRemove: [ProfileImages]
    @Binding var imagesToFavorite: [ProfileImages]
    @Binding var imagesToUnfavorite: [ProfileImages]
    
    func imageContent(url: URL, width: CGFloat, height: CGFloat, cardIndex: Int) -> some View {
        
        let context = ContextCardModifier(
            cardURL: url,
            isFavorite: cardIndex == 0 ? $isFavoriteOne : cardIndex == 1 ? $isFavoriteTwo : $isFavoriteThree,
            imagesToRemove: $imagesToRemove,
            imagesToFavorite: $imagesToFavorite,
            imagesToUnfavorite: $imagesToUnfavorite
        )
        
        var containsFavorite = false
        imagesToFavorite.forEach({ profileImages  in
            if profileImages.imageURL == url {
                containsFavorite = true
                return;
            }
        })
        
        let showFavorite = (isFavoriteOne && cardIndex == 0) || (isFavoriteTwo && cardIndex == 1) || (isFavoriteThree && cardIndex == 2) || containsFavorite
        let isRemoved = imagesToRemove.filter(){ $0.imageURL == url }.count > 0
        
        return ZStack(alignment: .topTrailing) {
            AsyncImage(
                url: url,
                content: { image in
                    NavigationLink(destination:
                                    image.resizable()
                                    .scaledToFill()
                                    .ignoresSafeArea()
                    ) {
                        image.resizable()
                        .scaledToFill()
                        .frame(width: width, height: height)
                        .cornerRadius(4)
                        .modifier(context)
                    }
                    .buttonStyle(PlainButtonStyle())
               },
               placeholder: {
                   ProgressView()
                       .frame(width: width, height: height, alignment: .center)
               })
            
            if showFavorite {
                Image(systemName: K.Icon.FavoriteFill)
                    .foregroundColor(Color.secondaryColor)
                    .font(height == 250 ? .title : .headline)
                    .padding(6)
            }
        }
        .opacity(isRemoved ? 0.5 : 1)
    }
    
    var body: some View {
    
        HStack(spacing: 4) {
            VStack(spacing: 4) {
                if cards.count >= 2 {
                    imageContent(url: cards[1], width: ((width / 3)), height: 123, cardIndex: 1)
                }
                
                if cards.count == 3 {
                    imageContent(url: cards[2], width: ((width / 3)), height: 123, cardIndex: 2)
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
            imageContent(url: cards[0], width: (width - (width / 3) + 4), height: 250, cardIndex: 0)
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
    }
}
