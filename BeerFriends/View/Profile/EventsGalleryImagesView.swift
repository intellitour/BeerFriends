//
//  EventsGalleryImagesView.swift
//  BeerFriends
//
//  Created by Wesley Marra on 11/12/21.
//

import SwiftUI

struct EventsGalleryImagesView: View {
    
    @Binding var urls: [URL]
    
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
                    ForEach(urls, id: \.self) { url in
                        GeometryReader { proxy in
                            let scale = getScale(proxy: proxy)
                            
                            AsyncImage(
                                url: url,
                                content: { image in
                                    NavigationLink(destination:
                                                    image.resizable()
                                                    .scaledToFill()
                                                    .ignoresSafeArea()
                                    ) {
                                        image .resizable()
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
                                },
                                placeholder: {
                                    ProgressView()
                                        .frame(width: scale, height: scale, alignment: .center)
                                })
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
        EventsGalleryImagesView(urls: .constant([]))
    }
}
