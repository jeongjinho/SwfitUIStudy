//
//  CoinDataService.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/22.
//

import Foundation
import Combine

final class CoinDataService {
    var coinSubscription: AnyCancellable?
    @Published var allcoins: [CoinModel] = []
    
    init() {
        getCoins()
    }
    
    private func getCoins() {
        
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        coinSubscription = NetworkingManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkingManager.handleCompletion(completion:), receiveValue: { [weak self] coins in
                self?.allcoins = coins
                self?.coinSubscription?.cancel() 
            })
    }
        
}
