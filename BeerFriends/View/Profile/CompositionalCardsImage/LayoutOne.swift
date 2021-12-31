//
//  LayoutOne.swift
//  BeerFriends
//
//  Created by Wesley Marra on 24/12/21.
//

import SwiftUI

var width = UIScreen.main.bounds.width - 30

struct LayoutOne: View {
    var cards: [URL]?
    
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
        
        let showFavorite = (isFavoriteOne && cardIndex == 0) || (isFavoriteTwo && cardIndex == 1) || (isFavoriteThree && cardIndex == 2)
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
            if (cards != nil) {
                imageContent(url: cards![0], width: (width - (width / 3) + 4), height: 250, cardIndex: 0)
                                            
                VStack(spacing: 4) {
                    if cards!.count >= 2 {
                        imageContent(url: cards![1], width: ((width / 3)), height: 123, cardIndex: 1)
                    }
                    
                    if cards!.count == 3 {
                        imageContent(url: cards![2], width: ((width / 3)), height: 123, cardIndex: 2)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

//struct LayoutOne_Previews: PreviewProvider {
//    static var previews: some View {
//        LayoutOne(cards: [
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2F5Xu3v7kQ7bRqF9oj7LABrPCcrFH2.jpg?alt=media&token=27c6b17d-95f8-4076-96a5-691ef255d6e1")!,
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2FOpZrZVBOW0gbgVBhG7c3x0OOcWo1.jpg?alt=media&token=f0d77794-9a11-4a78-9460-66bcb260987d")!,
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2FR96TMJVfubZ4lo2KPGJX3jir6n52.jpg?alt=media&token=b17522ae-98a6-4d2d-9918-f9390285059a")!,
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2Fjv2EdvPcJhRwUc8c2l4485AP9113.jpg?alt=media&token=ca10d287-e258-412b-9bb8-26f4b6316bcb")!,
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2F5Xu3v7kQ7bRqF9oj7LABrPCcrFH2.jpg?alt=media&token=27c6b17d-95f8-4076-96a5-691ef255d6e1")!,
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2FOpZrZVBOW0gbgVBhG7c3x0OOcWo1.jpg?alt=media&token=f0d77794-9a11-4a78-9460-66bcb260987d")!,
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2FR96TMJVfubZ4lo2KPGJX3jir6n52.jpg?alt=media&token=b17522ae-98a6-4d2d-9918-f9390285059a")!,
//            URL(string: "https://firebasestorage.googleapis.com/v0/b/beer-friends-bc763.appspot.com/o/profiles%2Fjv2EdvPcJhRwUc8c2l4485AP9113.jpg?alt=media&token=ca10d287-e258-412b-9bb8-26f4b6316bcb")!
//        ])
//    }
//}
