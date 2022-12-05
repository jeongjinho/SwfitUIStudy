//
//  SwiftfulCriptoApp.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/16.
//

import SwiftUI

@main
struct SwiftfulCriptoApp: App {
    
    
    
    @StateObject private var vm = HomeViewModel()
    
    
    init() {
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor : UIColor(Color.theme.accent)]
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                HomeView()
                    .navigationBarHidden(true)
            }
            .environmentObject(vm)
        }
    }
}
