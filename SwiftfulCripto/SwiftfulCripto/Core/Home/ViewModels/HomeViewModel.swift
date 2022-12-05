//
//  HomeViewModel.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/22.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    
    @Published var statistics: [StatisticModel] = []
    
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    private var cancellables = Set<AnyCancellable>()
    private let coinDataService = CoinDataService()
    private let marketDataService = MarketDataService()
    private let portfolioDataService = PortfolioDataService()
    
    init() {
        addSubscrbiers()
    }
    
    func addSubscrbiers() {
        
        //updates allCoins
        $searchText
            .combineLatest(coinDataService.$allcoins)
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink(receiveValue: { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            })
            .store(in: &cancellables)
        
        marketDataService.$marketData
            .map(mapGlobalMarketData)
            .sink { [weak self] returnedStats in
                self?.statistics = returnedStats
            }
            .store(in: &cancellables)
        
       $allCoins
            .combineLatest(portfolioDataService.$saveEntities)
            .map { (coinModels, portfolioEntities) in
                return coinModels.compactMap { coin -> CoinModel? in
                    guard let entity = portfolioEntities.first(where: { $0.coinID == coin.id}) else { return nil}
                    return coin.updateHoldings(amount: entity.amount)
                }
            }
            .sink { returnedCoins in
                self.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePorfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePorfolio(coin: coin, amount: amount)
    }
    
    private func filterCoins(text: String, coins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return coins }
        
        //
        let lowercasedText = text.lowercased()
        return coins.filter{ coin -> Bool in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func mapGlobalMarketData(data: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = data else {
            return stats
        }
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentCHnage: data.marketCapChangePercentage24HUsd)
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let dominence = StatisticModel(title: "BTC Dominence", value: data.btcDominence)
        let portfolio = StatisticModel(title: "Portfolio", value: "$0.00", percentCHnage: 0)
        
        stats.append(contentsOf: [
            marketCap,
            volume,
            dominence,
            portfolio
        ])
        return stats
    }
}
