//
//  PhotoMdoel.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/09/15.
//

import Foundation





struct PhotoModel: Identifiable, Codable {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
}
