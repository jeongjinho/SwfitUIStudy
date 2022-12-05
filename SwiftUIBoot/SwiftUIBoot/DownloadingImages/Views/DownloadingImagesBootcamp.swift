//
//  DownloadingImagesBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/09/15.
//

import SwiftUI
// Codable
// background Threads
// weak self
// Combine
// Publishers and Subscribers
// FileManager
// NSCache

struct DownloadingImagesBootcamp: View {
    @StateObject var vm = DownloadingImagesViewModel()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(vm.dataArray) { model in
                    DownloadingImagesRow(model: model)
                }   
            }
            .navigationTitle("DownloadingImages")
        }
    }
}

struct DownloadingImagesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImagesBootcamp()
    }
}
