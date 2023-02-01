//
//  TabBar.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2023/01/10.
//

import SwiftUI

struct TabBar: View {
    var body: some View {
        TabView {
        
            Home()
                .tabItem {
                    Image(systemName: "play.circle.fill")
                    Text("Home")
                }
            
            LayoutAndStacks()
                .tabItem {
                    Image(systemName: "rectangle.stack.fill")
                    Text("Certificate")
                }
        }
        
        .edgesIgnoringSafeArea(.top)
    }
}

struct TabBar_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            TabBar()
                .previewDevice("iPhone 11 Pro Max")
            TabBar()
                .previewDevice("iPhone 11")
        }
        
    }
}
