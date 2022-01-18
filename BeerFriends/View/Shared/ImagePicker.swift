//
//  ImagePicker.swift
//  BeerFriends
//
//  Created by Wesley Marra on 21/12/21.
//

import SwiftUI

struct ImagePicker: UIViewControllerRepresentable {
    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?
    @Binding var sourceType: UIImagePickerController.SourceType

    func makeCoordinator() -> Coordinator {
       return Coordinator(isShown: $isShown, uiImage: $uiImage)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> UIImagePickerController {
       let picker = UIImagePickerController()
       picker.delegate = context.coordinator
       picker.sourceType = sourceType
       return picker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController,
                               context: UIViewControllerRepresentableContext<ImagePicker>) {
    }
}

func compressImage(image: UIImage) -> UIImage {
        let resizedImage = image.aspectFittedToHeight(200)
        resizedImage.jpegData(compressionQuality: 0.2)

        return resizedImage
}

class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    @Binding var isShown: Bool
    @Binding var uiImage: UIImage?

    init(isShown: Binding<Bool>, uiImage: Binding<UIImage?>) {
        _isShown = isShown
        _uiImage = uiImage
    }

    func imagePickerController(_ picker: UIImagePickerController,
                              didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let imagePicked = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        uiImage = compressImage(image: imagePicked)
        isShown = false
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        isShown = false
    }
}
