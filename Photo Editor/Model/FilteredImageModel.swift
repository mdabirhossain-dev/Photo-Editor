//
//  FilteredImageModel.swift
//  Photo Editor
//
//  Created by Md Abir Hossain on 19/5/24.
//

import UIKit

struct FilteredImageModel: Identifiable {
    var id = UUID().uuidString
    var image: UIImage
    var filter: CIFilter
}
