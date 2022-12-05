//
//  MarketDataService.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/26.
//

import Foundation
import Combine

final class MarketDataService {
    var marketDataModelSubscription: AnyCancellable?
    @Published var marketData: MarketDataModel?
    
    init() {
        getData()
    }
    
    private func getData() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataModelSubscription = NetworkingManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] globalData in
                self?.marketData = globalData.data
                self?.marketDataModelSubscription?.cancel()
            })
    }
}
