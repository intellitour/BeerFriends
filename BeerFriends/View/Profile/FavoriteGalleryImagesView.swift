//
//  FavoriteGalaryImagesView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 11/12/21.
//

import SwiftUI

struct FavoriteGalleryImagesView: View {
    // Mock
    @State var favorites = [
        Gallery(id: 0, image: "image1", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 1, image: "image2", offset: 0, title: "Chapada Diamantina"),
        Gallery(id: 2, image: "image3", offset: 0, title: "Por do sol"),
        Gallery(id: 3, image: "image4", offset: 0, title: "Barzinho na beira da praia"),
        Gallery(id: 4, image: "image5", offset: 0, title: "Cervejaria Vórtex BrewHouse"),
        Gallery(id: 5, image: "image6", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 6, image: "image7", offset: 0, title: "Chapada Diamantina"),
    ]
    
    @State var scrolled = 0
    
    func onChangeDragGesture(value: DragGesture.Value, favorite: Gallery) {
        if  value.translation.width < 0 && favorite.id != favorites.last!.id {
            favorites[favorite.id].offset = value.translation.width
        } else {
            if favorite.id > 0 {
                favorites[favorite.id - 1].offset = -(calculateWidth() + 60) + value.translation.width
            }
        }
    }
    
    func onEndedDragGesture(value: DragGesture.Value, favorite: Gallery) {
        if value.translation.width < 0 {
            if (-value.translation.width) > 180 && favorite.id != favorites.last!.id {
                favorites[favorite.id].offset = -(calculateWidth() + 60)
                scrolled += 1
            } else {
                favorites[favorite.id].offset = 0
            }
        } else {
            if favorite.id > 0 {
                if value.translation.width > 180 {
                    favorites[favorite.id - 1].offset = 0
                    scrolled -= 1
                } else {
                    favorites[favorite.id - 1].offset = -(calculateWidth() + 60)
                }
            }
        }
    }
    
    func calculateWidth() -> CGFloat {
        let screen = UIScreen.main.bounds.width - 30
        let width = screen - (2 * 30)
        return width
    }
    
    var body: some View {
        ForEach(favorites.reversed()) { favorite in
            HStack {
                ZStack(alignment: Alignment(horizontal: .leading, vertical: .bottom)) {
                    Image(favorite.image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: calculateWidth(), height: UIScreen.main.bounds.height / 1.8 - CGFloat(favorite.id - scrolled) * 50)
                        .cornerRadius(15)
                        .offset(x: favorite.id - scrolled <= 2 ? CGFloat(favorite.id - scrolled) * 30 : 60)
                }
                
                Spacer(minLength: 0)
            }
            .contentShape(Rectangle())
            .offset(x: favorite.offset)
            .gesture(DragGesture().onChanged({ (value) in
                withAnimation {
                    onChangeDragGesture(value: value, favorite: favorite)
                }
            }).onEnded({ (value) in
                withAnimation {
                   onEndedDragGesture(value: value, favorite: favorite)
                }
            }))
        }
    }
}

// Mock
struct Gallery: Identifiable {
    var id: Int
    var image: String
    var offset: CGFloat
    var title: String
}
