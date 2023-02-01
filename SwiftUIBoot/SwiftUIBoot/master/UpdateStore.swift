//
//  UpdateStore.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2023/01/10.
//

import SwiftUI
import Combine


class UpdateStore: ObservableObject {
    @Published var updates: [Update] = updateData
    
}

//struct UpdateStore: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct UpdateStore_Previews: PreviewProvider {
//    static var previews: some View {
//        UpdateStore()
//    }
//}
