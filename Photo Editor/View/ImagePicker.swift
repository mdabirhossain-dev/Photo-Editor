//
//  ImagePicker.swift
//  Photo Editor
//
//  Created by Md Abir Hossain on 19/5/24.
//

import SwiftUI
import PhotosUI

struct ImagePicker: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(parent: self)
    }
    
    
    @Binding var picker: Bool
    @Binding var imageData: Data
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        
        let picker = PHPickerViewController(configuration: PHPickerConfiguration())
        picker.delegate = context.coordinator
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        
        var parent: ImagePicker
        
        init(parent: ImagePicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            
            // checking image is selected or cancelled
            if !results.isEmpty {
                // Checking image can be loaded...
                if results.first!.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    results.first?.itemProvider.loadObject(ofClass: UIImage.self, completionHandler: { (image, err) in
                        DispatchQueue.main.async {
                            self.parent.imageData = (image as? UIImage)?.pngData() ?? Data()
                            self.parent.picker.toggle()
                        }
                    })
                }
            } else {
                parent.picker.toggle()
            }
        }
        
        
    }
}

