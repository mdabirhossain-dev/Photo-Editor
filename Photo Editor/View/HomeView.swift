//
//  HomeView.swift
//  Photo Editor
//
//  Created by Md Abir Hossain on 19/5/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var filterData = FilterViewModel()
    
    var body: some View {
        VStack {
            if !filterData.allImages.isEmpty && filterData.mainView != nil {
                Image(uiImage: filterData.mainView.image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: UIScreen.main.bounds.width)
                
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(filterData.allImages) { filtered in
                            Image(uiImage: filtered.image)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 150, height: 150)
                                .onTapGesture {
                                    // Updating Selected Image(mainView) onTap
                                    filterData.mainView = filtered
                                }
                        }
                    }
                    .padding()
                }
                .padding(.top, 60)
            } else if filterData.imageData.count == 0 {
                Button("Select an image") {
                    filterData.imagePicker.toggle()
                }
                .buttonStyle(BorderedProminentButtonStyle())
            } else {
                ProgressView()
            }
        }
        .onChange(of: filterData.imageData, perform: { (_) in
            // Calling ReloadImage if image is changed
            // Clearing existingData
            self.filterData.allImages.removeAll()
            self.filterData.loadFilter()
        })
        .sheet(isPresented: $filterData.imagePicker) {
            ImagePicker(picker: $filterData.imagePicker, imageData: $filterData.imageData)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("+") {
                    filterData.imagePicker.toggle()
                }
                .buttonStyle(BorderedProminentButtonStyle())
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}