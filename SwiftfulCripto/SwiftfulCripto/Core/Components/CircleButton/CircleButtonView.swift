//
//  CircleButtonView.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/19.
//

import SwiftUI

struct CircleButtonView: View {
    
    let iconName: String
    
    var body: some View {
       Image(systemName: iconName)
            .font(.system(size: 30))
            .foregroundColor(Color.theme.accent)
            .frame(width: 50, height: 50)
            .background(
                Circle()
                    .foregroundColor(Color.theme.background)
            )
            .shadow(color: Color.theme.accent.opacity(0.25), radius: 10)
            .padding(30)
    }
}

struct CircleButtonView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            CircleButtonView(iconName: "info")
                .padding()
                .previewLayout(.sizeThatFits)
            CircleButtonView(iconName: "plus")
                .padding()
                .previewLayout(.sizeThatFits)
                .colorScheme(.dark)
        }
        
    }
}
