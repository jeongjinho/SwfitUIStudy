//
//  CoinImageViewModel.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/23.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = true
    private let coin: CoinModel
    private let dataService: CoinImageService
    private var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.dataService = CoinImageService(coin: coin)
        addSubscribers()
    }
    
    private func addSubscribers() {
        
        dataService.$image.sink { [weak self] _ in
            self?.isLoading = false
        } receiveValue: { [weak self] image in
            self?.image = image
        }
        .store(in: &cancellables)

    }
}
