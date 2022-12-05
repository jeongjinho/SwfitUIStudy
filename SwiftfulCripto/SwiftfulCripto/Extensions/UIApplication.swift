//
//  UIApplication.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/23.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    
    
}
