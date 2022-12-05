//
//  CoinImageService.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageService {
    @Published var image: UIImage? = nil
    
    var imageSubscription: AnyCancellable?
    private var coin: CoinModel
    private let fileManager: LocalFileManager = LocalFileManager.instance
    private let folderName: String = "coin_images"
    private let imageName: String
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    private func getCoinImage() {
        if let savedImage = fileManager.getImage(imageName: imageName, folderName: folderName) {
            image = savedImage
            print("Retrived image from File manager!")
        } else {
            downloadCoinImage()
            print("Download image now")
            
        }
    }
    
    private func downloadCoinImage() {
        
        guard let url = URL(string: coin.image) else { return }
        
        imageSubscription = NetworkingManager.download(url: url)
            .tryMap({ data in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] returnedImage in
                guard let self = self, let downloadedImage = returnedImage else { return }
                self.image = returnedImage
                self.imageSubscription?.cancel()
                self.fileManager.saveImage(image: downloadedImage, imageName: self.imageName, folderName: self.folderName)
            })
    }
}
