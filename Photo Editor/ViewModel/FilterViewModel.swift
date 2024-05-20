//
//  HomeViewModel.swift
//  Photo Editor
//
//  Created by Md Abir Hossain on 19/5/24.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

class FilterViewModel: ObservableObject {
    @Published var imagePicker = false
    @Published var imageData = Data(count: 0)
    
    @Published var allImages: [FilteredImageModel] = []
    
    // Main Editing image
    @Published var mainView: FilteredImageModel!
    
    // Loading filtered image when image is selected
    let filters: [CIFilter] = [
        CIFilter.gaussianBlur(), CIFilter.sepiaTone(), CIFilter.comicEffect(), CIFilter.bloom(), CIFilter.photoEffectChrome(), CIFilter.photoEffectFade(), CIFilter.colorInvert(), CIFilter.colorMonochrome(), CIFilter.bumpDistortion(), CIFilter.boxBlur(), CIFilter.circularScreen()
    ]
    
    func loadFilter() {
        
        let context = CIContext()
        
        filters.forEach { (filter) in
            
            DispatchQueue.global(qos: .userInteractive).async {
                // Loading image into filter...
                let ciImage = CIImage(data: self.imageData)
                
                filter.setValue(ciImage!, forKey: kCIInputImageKey)
                
                // Retriving image
                guard let newImage = filter.outputImage else { return }
                
                // Creating UIImage...
                let cgImage = context.createCGImage(newImage, from: newImage.extent)
                let filteredData = FilteredImageModel(image: UIImage(cgImage: cgImage!), filter: filter)
                
                DispatchQueue.main.async {
                    self.allImages.append(filteredData)
                    
                    // First filter is default filter
                    if self.mainView == nil {
                        self.mainView = self.allImages.first
                    }
                }
            }
        }
    }
}

