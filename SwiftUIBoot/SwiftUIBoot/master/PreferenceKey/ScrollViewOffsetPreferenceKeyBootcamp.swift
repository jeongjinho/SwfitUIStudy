//
//  ScrollViewOffsetPreferenceKeyBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/15.
//

import SwiftUI
 
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
    static var defaultValue: CGFloat = 0
    
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}


extension View {
    
    func onScrollViewOffsetChanged(action: @escaping (_ offset: CGFloat) -> Void ) -> some View {
        self
            .background(
                GeometryReader { geo in
                    Text("")
                        .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
                }
            )
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
              action(value)
            }
    }
}

struct ScrollViewOffsetPreferenceKeyBootcamp: View {
    
    @State private var scrollViewOffset: CGFloat = 0
    
    let title : String = "New title here!!!"
    
    var body: some View {
//NavigationView {
            ScrollView {
                VStack {
                   titleLayer
                        .opacity(scrollViewOffset / 63.0)
                        .onScrollViewOffsetChanged { offset in
                            self.scrollViewOffset = offset
                        }
//                        .background(
//                            GeometryReader { geo in
//                                Text("")
//                                    .preference(key: ScrollViewOffsetPreferenceKey.self, value: geo.frame(in: .global).minY)
//                            }
//                        )
                    
                   contentLayer
                }
                .padding()
            }
            .overlay(Text("\(scrollViewOffset)"))
//            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
//                scrollViewOffset = value
//            }
            .overlay(
                naviBarLayer
                    .opacity( 1.0 - (scrollViewOffset / 63))
                
                ,alignment: .top)
           
        //    .navigationTitle("Nav Title Here")
      //  }
    }
}

struct ScrollViewOffsetPreferenceKeyBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        ScrollViewOffsetPreferenceKeyBootcamp()
    }
}


extension ScrollViewOffsetPreferenceKeyBootcamp {
    
    private var titleLayer: some View {
        Text(title)
            .font(.largeTitle)
            .fontWeight(.semibold)
            .frame(maxWidth: .infinity, alignment: .leading)
        
    }
    
    private var contentLayer: some View {
        ForEach(0..<30) { _ in
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.red.opacity(0.3))
                .frame(width: 300, height: 200)
        }
    }
    
    private var naviBarLayer: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(height: 55)
            .background(Color.blue)
    }
    
}
