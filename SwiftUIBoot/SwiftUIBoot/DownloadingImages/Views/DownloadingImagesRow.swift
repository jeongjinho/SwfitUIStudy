//
//  DownloadingImagesRow.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/09/15.
//

import SwiftUI

struct DownloadingImagesRow: View {
    
    let model: PhotoModel
    
    init(model: PhotoModel) {
        self.model = model
        print("init DownloadingImagesRow")
    }
    
    var body: some View {
        HStack {
            DownloadingImageView(url: model.url, key: "\(model.id)")
                .frame(width: 75, height: 75)
            
            VStack(alignment: .leading) {
                Text(model.title)
                    .font(.headline)
                Text(model.url)
                    .foregroundColor(.gray)
                    .italic()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

struct DownloadingImagesRow_Previews: PreviewProvider {
    static var previews: some View {
        DownloadingImagesRow(model: PhotoModel(albumId: 1, id: 1, title: "sss", url: "https://via.placeholder.com/600/92c952", thumbnailUrl: "dsasdjksahdsakjdhsakjdhsakjdhasjkdhsakjdhsajkdhsajkdhaskjddsd"))
            .padding()
            .previewLayout(.sizeThatFits)
    }
}
