//
//  StasticsModel.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/24.
//

import Foundation


struct StatisticModel: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let value: String
    let percentCHnage: Double?
    
    
    init(title: String, value: String, percentCHnage: Double? = nil) {
        self.title = title
        self.value = value
        self.percentCHnage = percentCHnage
    }
}


let newModel = StatisticModel(title: "", value: "", percentCHnage: nil)
