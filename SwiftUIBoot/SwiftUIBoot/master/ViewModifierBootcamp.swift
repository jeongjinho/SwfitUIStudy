//
//  ViewModifierBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/10/14.
//

import SwiftUI

struct DefaultButtonViewModifier: ViewModifier {
    
    var backgroundColor: Color
    func body(content: Content) -> some View {
        content
             
            .foregroundColor(.white)
            .frame(height: 55)
            .frame(maxWidth: .infinity)
            .background(backgroundColor)
            .cornerRadius(10)
            .shadow(radius: 10)
            .padding()
    }
    
}

extension View {
    
    func withDefaultButtonFormatting(backgroundColor: Color) -> some View {
        
        modifier(DefaultButtonViewModifier(backgroundColor: backgroundColor))
    }
}

struct ViewModifierBootcamp: View {
    
    var body: some View {
        VStack(spacing: 10) {
            
            Text("Hello world!")
                .font(.headline)
                .withDefaultButtonFormatting(backgroundColor: .red)
//                .font(.subheadline)
//                .foregroundColor(.white)
//                .frame(height: 55)
//                .frame(maxWidth: .infinity)
//                .background(Color.blue)
//                .cornerRadius(10)
//                .shadow(radius: 10)
//                .padding()
            
            Text("Hello world!!")
                .font(.subheadline)
                .modifier(DefaultButtonViewModifier(backgroundColor: .blue))
            

            Text("Hello world!!!")
                .font(.title)
                .modifier(DefaultButtonViewModifier(backgroundColor: .blue))
                
        }
        
    }
}

struct ViewModifierBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ViewModifierBootcamp()
    }
}
