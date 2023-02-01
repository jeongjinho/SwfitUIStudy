//
//  Modifiers.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2023/01/31.
//

import SwiftUI


struct ShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        
        
        content
            .shadow( color: .black.opacity(0.1), radius: 10, x: 0, y: 12)
            .shadow( color: .black.opacity(0.1), radius: 1, x: 0, y: 1)
    }
}


struct FontModifier: ViewModifier {
    
    var style: Font.TextStyle = .body
    
    func body(content: Content) -> some View {
        content
            .font(.system(style, design: .default))
    }
}
