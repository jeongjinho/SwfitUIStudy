//
//  SearchBarView.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/23.
//

import SwiftUI

struct SearchBarView: View {
    
    @Binding var searchText: String
    var body: some View {
        HStack {
            
            Image(systemName: "magnifyingglass")
                .foregroundColor(searchText.isEmpty ? Color.theme.secondaryText : Color.theme.accent)
            TextField("Search by name of symbol...", text: $searchText)
                .foregroundColor(Color.theme.accent)
                .disableAutocorrection(true)
                .overlay(
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color.theme.accent)
                        .padding()
                        .offset(x: 10)
                        .opacity(searchText.isEmpty ? 0.0 : 1.0)
                        .onTapGesture {
                            UIApplication.shared.endEditing()
                            searchText = ""
                        }
                    ,alignment: .trailing
                    
                )
            
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 25)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.15), radius: 10)
               
        )
        .padding()
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            SearchBarView(searchText: .constant(""))
                .preferredColorScheme(.dark)
                .previewLayout(.sizeThatFits)
            SearchBarView(searchText: .constant(""))
                .preferredColorScheme(.light)
                .previewLayout(.sizeThatFits)
        }
        
    }
}
