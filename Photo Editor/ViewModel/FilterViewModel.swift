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
    
    // Slider for intensity and radious (initial value is full)
    @Published var value: CGFloat = 1.0
    
    // Loading filtered image when image is selected
    let filters: [CIFilter] = [
        CIFilter.sepiaTone(), CIFilter.photoEffectChrome(), CIFilter.comicEffect(), CIFilter.bloom(), CIFilter.photoEffectFade(), CIFilter.colorInvert(), CIFilter.gaussianBlur(), CIFilter.colorMonochrome(), CIFilter.bumpDistortion(), CIFilter.boxBlur(), CIFilter.circularScreen()
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
                guard let image = cgImage else { return }
                
                let isEditable = filter.inputKeys.count > 1
                
                let filteredData = FilteredImageModel(image: UIImage(cgImage: image),
                                                      filter: filter,
                                                      isEditable: isEditable)
                
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
    
    func updateEffect() {
        
        let context = CIContext()
        
        DispatchQueue.global(qos: .userInteractive).async {
            // Loading image into filter...
            let ciImage = CIImage(data: self.imageData)
            guard let image = ciImage else { return }
            
            let filter = self.mainView.filter
            
            filter.setValue(image, forKey: kCIInputImageKey)
            
            // Retriving image
            // Reading input key
//            print(filter.inputKeys)
            
            // Radius up to 100(using 10)
            if filter.inputKeys.contains("inputRadius") {
                filter.setValue(self.value * 10, forKey: kCIInputRadiusKey)
            }
            
            if filter.inputKeys.contains("inputIntensity") {
                filter.setValue(self.value, forKey: kCIInputIntensityKey)
            }
            
            guard let newImage = filter.outputImage else { return }
            
            // Creating UIImage...
            let cgImage = context.createCGImage(newImage, from: newImage.extent)
            guard let image = cgImage else { return }
            
            DispatchQueue.main.async {
                // Updating view
                self.mainView.image = UIImage(cgImage: image)
            }
        }
    }
}

