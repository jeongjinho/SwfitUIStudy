//
//  Double.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/21.
//

import Foundation


extension Double {
    
    /// convents a double into a Currency with 2 decimal places
    ///```
    ///Convert 1234.56 to $1.234.56
   
    ///```
    private var currencyFormatter2: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current // default value
//        formatter.currencyCode = "usd" // change currency
//        formatter.currencySymbol = "$" // change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter
    }
    
    /// convents a double into a Currency as String with 2 decimal places
    ///```
    ///Convert 1234.56 to "$1.234.56"
    ///```
    ///
    func asCurrencyWith2Decimal() -> String {
        let number = NSNumber(value:  self)
        return currencyFormatter2.string(from: number) ?? "$0.00"
    }
    
    

    
    /// convents a double into a Currency with 2-6 decimal places
    ///```
    ///Convert 1234.56 to $1.234.56
    ///Convert 12.3456 to $12.34.56
    ///Convert 0.123456 to $0.123456
    ///```
    private var currencyFormatter6: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.usesGroupingSeparator = true
        formatter.numberStyle = .currency
//        formatter.locale = .current // default value
//        formatter.currencyCode = "usd" // change currency
//        formatter.currencySymbol = "$" // change currency symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 6
        return formatter
    }
    
    /// convents a double into a Currency as String with 2-6 decimal places
    ///```
    ///Convert 1234.56 to "$1.234.56"
    ///Convert 12.3456 to "$12.34.56"
    ///Convert 0.123456 to "$0.123456"
    ///```
    ///
    func asCurrencyWith6Decimal() -> String {
        let number = NSNumber(value:  self)
        return currencyFormatter6.string(from: number) ?? "$0.00"
    }
    
    
    /// convents a double into  String with 2-6 decimal places
    ///```
    ///Convert 1.23456 to "1.23"
    ///```
    ///
    func asNumberString() -> String {
        return String(format: "%.2f", self)
    }
    
    
    /// convents a double into  String  representationwith percent symbol
    func asPercentString() -> String {
        return asNumberString() + "%"
    }
    
    func formattedWithAbbrevations() -> String {
        let num = abs(Double(self))
        let sign = (self < 0) ? "-" : ""
        
        switch num {
        case 1_000_000_000_000...:
            let formatted = num / 1_000_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Tr"
        case 1_000_000_000...:
            let formatted = num / 1_000_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)Bn"
        case 1_000_000...:
            let formatted = num / 1_000_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)M"
        case 1_000...:
            let formatted = num / 1_000
            let stringFormatted = formatted.asNumberString()
            return "\(sign)\(stringFormatted)K"
        case 0...:
            return self.asNumberString()
        default:
            return "\(sign)\(self)"
        }
    }
}
