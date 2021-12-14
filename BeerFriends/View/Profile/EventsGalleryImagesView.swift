//
//  EventsGalleryImagesView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 11/12/21.
//

import SwiftUI

struct EventsGalleryImagesView: View {
    
    // Mock
    @State var events = [
        Gallery(id: 0, image: "image1", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 1, image: "image2", offset: 0, title: "Chapada Diamantina"),
        Gallery(id: 2, image: "image3", offset: 0, title: "Por do sol"),
        Gallery(id: 3, image: "image4", offset: 0, title: "Barzinho na beira da praia"),
        Gallery(id: 4, image: "image5", offset: 0, title: "Cervejaria Vórtex BrewHouse"),
        Gallery(id: 5, image: "image6", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 6, image: "image7", offset: 0, title: "Chapada Diamantina"),
        Gallery(id: 7, image: "image8", offset: 0, title: "Por do sol"),
        Gallery(id: 8, image: "image9", offset: 0, title: "Barzinho na beira da praia"),
        Gallery(id: 9, image: "image10", offset: 0, title: "Cervejaria Vórtex BrewHouse"),
        Gallery(id: 10, image: "image11", offset: 0, title: "Cervejaria Dogma"),
        Gallery(id: 11, image: "image12", offset: 0, title: "Chapada Diamantina"),
        Gallery(id: 12, image: "image13", offset: 0, title: "Por do sol"),
        Gallery(id: 13, image: "image14", offset: 0, title: "Barzinho na beira da praia"),
        Gallery(id: 14, image: "image15", offset: 0, title: "Cervejaria Vórtex BrewHouse")
    ]
    
    private func getScale(proxy: GeometryProxy) -> CGFloat {
        var scale: CGFloat = 1
        let x = proxy.frame(in: .global).minX
        let diff = abs(x - 60)
        
        if diff < 100 {
            scale = 1 + (100 - diff) / 700
        }
        return scale
    }
    
    var body: some View {
        ScrollView {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 50) {
                    ForEach(events.reversed()) { event in
                        GeometryReader { proxy in
                            NavigationLink(destination: Image(event.image)) {
                                let scale = getScale(proxy: proxy)
                                
                                Image(event.image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 250)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 15).stroke(lineWidth: 0.5)
                                    )
                                    .clipped()
                                    .cornerRadius(15)
                                    .shadow(radius: 5)
                                    .scaleEffect(CGSize(width: scale, height: scale))
                            }
                        }
                        .frame(width: 240, height: UIScreen.main.bounds.height / 2)
                    }
                }
                .padding(32)
            }
        }
    }
}

struct EventsGalleryImagesView_Previews: PreviewProvider {
    static var previews: some View {
        EventsGalleryImagesView()
    }
}
