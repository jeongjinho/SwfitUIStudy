//
//  GeometryPreferenceKeyBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/14.
//

import SwiftUI

struct GeometryPreferenceKeyBootcamp: View {
    @State private var rectSize: CGSize = .zero
    var body: some View {
        
        VStack {
            
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .frame(width: rectSize.width, height: rectSize.height)
                .background(
                    Rectangle()
                        .fill(Color.red)
                )
                .overlay {
                    Text("\(rectSize.height)")
                        .foregroundColor(.white)
                    
                }
            
            
                .border(Color.red)
            
            Spacer()
            HStack {
                Rectangle()
                GeometryReader { geo in
                    Rectangle()
                        .updateRectangleGeoSize(geo.size)
                        .overlay {
                            Text("\(geo.size.height)")
                                .foregroundColor(.white)
                        }
                }
               
                Rectangle()
            }
            .frame(height: 55)
        }
        .onPreferenceChange(RectangleGeometryPreferenceKey.self) { value in
            self.rectSize = value
        }
    }
}

struct GeometryPreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GeometryPreferenceKeyBootcamp()
    }
}

extension View {
    func updateRectangleGeoSize(_ size: CGSize) -> some View {
        
        preference(key: RectangleGeometryPreferenceKey.self, value: size)
    }
}

struct RectangleGeometryPreferenceKey: PreferenceKey {
 
    static var defaultValue: CGSize  = .zero
    
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}
