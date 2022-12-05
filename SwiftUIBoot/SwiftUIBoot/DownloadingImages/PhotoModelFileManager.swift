//
//  PhotoModelFileManager.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/09/16.
//

import Foundation
import SwiftUI

class PhotoModelFileManager {
    let folderName = "downloaded_photos"
    
    static let instance = PhotoModelFileManager()
    
    private init() {
        createFolderIfNeeded()
    }
    
    
    private func createFolderIfNeeded() {
         
        guard let url = getFolderPath() else { return }
        if !FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                
                print("create Folder")
            } catch let error {
                print("error creating folder. \(error)")
            }
        }
        
    }
    
    
    private func getFolderPath() -> URL? {
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?.appendingPathComponent(folderName)
    }
    // .../downloaded_photos/image_name.png
    private func getImagePath(key: String) -> URL? {
        guard let folder = getFolderPath() else { return nil }
        return folder.appendingPathComponent(key + ".png")
    }
    
    func add(key: String, value: UIImage) {
        
        guard let data = value.pngData(), let url = getImagePath(key: key) else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            
            print("error write . \(error)")
        }
    }
    
    
    
    func get(key: String) -> UIImage? {
        guard let url = getImagePath(key: key), FileManager.default.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }
    
}
