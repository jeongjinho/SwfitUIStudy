//
//  PreferencKeyBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/14.
//

import SwiftUI

struct PreferencKeyBootcamp: View {
    @State private var text: String = "Hello, world!"
    var body: some View {
        NavigationView {
            VStack {
                SecondaryScreen(text: text)
                    .navigationTitle("navigation Title")
                    
//                    .preference(key: CustomTitlePreferenceKey.self, value: "New Value")
                
            }
           
        }
        .onPreferenceChange(CustomTitlePreferenceKey.self) { value in
            self.text = value
        }
    }
}

extension View {
    
    func customTitle(text: String) -> some View {
        self.preference(key:CustomTitlePreferenceKey.self, value: text)
    }
}

struct PreferencKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        PreferencKeyBootcamp()
    }
}


struct SecondaryScreen: View {
    @State private var newValue: String = ""
    let text: String
    
    
    var body: some View {
        Text(text)
            .onAppear {
                getDataFromDatabase()
            }
            .customTitle(text: newValue)
    }
    
    func getDataFromDatabase() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0, execute: {
            self.newValue = "NEW VALUE DATABASE!!"
            
        })
    }
}


struct CustomTitlePreferenceKey: PreferenceKey {
    
    static var defaultValue: String = ""
    
    static func reduce(value: inout String, nextValue: () -> String) {
        value = nextValue()
    }
}
