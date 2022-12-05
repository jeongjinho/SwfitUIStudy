//
//  PreviewProvider.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/21.
//

import Foundation
import SwiftUI

extension PreviewProvider {
    
    static var dev: DeveloperPreview {
        return DeveloperPreview.instance
    }
}


class DeveloperPreview {
    
    static let instance = DeveloperPreview()
    private init () { }
    
    let homeVM = HomeViewModel()
    
    let coin = CoinModel(id: "bitcoin", symbol: "btc", name: "Bitcoin", image: "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579", currentPrice: 18699.02, marketCap: 358132868864, marketCapRank: 1, fullyDilutedValuation: 392628313773, totalVolume: 37676684837, high24H: 20020, low24H: 18421.2, priceChange24H:  -1224.9405388544983, priceChangePercentage24H: -6.14808, marketCapChange24H: -23455022887.007385, marketCapChangePercentage24H: -6.14669, circulatingSupply: 19154987, totalSupply: 21000000, maxSupply: 21000000, ath: 69045, athChangePercentage: -72.88427, athDate: "2021-11-10T14:24:11.849Z", atl: 67.81, atlChangePercentage: 27509.89746, atlDate: "2013-07-06T00:00:00.000Z", lastUpdated: "2022-09-19T12:06:50.997Z", sparklineIn7D: .init(price: [
        22292.742909584467,
        22359.170072565197,
        22391.447255851035
    ]), priceChangePercentage24HInCurrency: -6.1480781707579695, currentHoldings: 1.5)
    
    
    let stat1 = StatisticModel(title: "Market Cap", value: "$12.5Bn", percentCHnage: 25.34)
    let stat2 = StatisticModel(title: "Total Volume", value: "$1.23Tr")
    let stat3 = StatisticModel(title: "Portfolio Value", value: "$50.4k", percentCHnage: -12.34)
}

