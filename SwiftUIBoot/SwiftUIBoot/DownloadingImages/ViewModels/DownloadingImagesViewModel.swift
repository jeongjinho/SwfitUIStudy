//
//  DownloadingImagesViewModel.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/09/15.
//

import Foundation
import Combine

class DownloadingImagesViewModel: ObservableObject {
    var cancellables = Set<AnyCancellable>()
    @Published var dataArray: [PhotoModel] = []
   
    let dataService = PhotoModelDataService.instance
    
   
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        
        dataService.$photoModels
            .sink { [weak self] returnedPhotoModels in
                self?.dataArray = returnedPhotoModels
            }
            .store(in: &cancellables)
    }
}

