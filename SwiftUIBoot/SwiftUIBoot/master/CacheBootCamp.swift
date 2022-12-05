//
//  CacheBootCamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/09/14.
//

import SwiftUI

class CacheManager {
    
    static let instance = CacheManager() // sington
    private init() { }
    
    var imageCache: NSCache<NSString, UIImage> = {
       let cache = NSCache<NSString, UIImage>()
        cache.countLimit = 100
        cache.totalCostLimit = 1024 * 1024 * 100
        return cache
    }()
    
    
    func add(image: UIImage, name: String) -> String {
        imageCache.setObject(image, forKey: name as NSString)
        return "Added to Cache!"
    }
    
    func remove(name: String) -> String {
        imageCache.removeObject(forKey: name as NSString)
        return "Removed to Cache!"

    }
    
    func get(name: String) -> UIImage? {
        return imageCache.object(forKey: name as NSString)
    }
}


class CacheViewModel: ObservableObject {
    @Published var startingImage: UIImage? = nil
    @Published var cachedImage: UIImage?  = nil
    @Published var infoMessage: String = ""
    let imageName: String = "steve-jobs"
    let manager = CacheManager.instance
    init() {
        getImageFromAssetsfolder()
    }
    
    func getImageFromAssetsfolder() {
        startingImage = UIImage(named: imageName)
    }
    
    func saveToCache() {
        guard let image = startingImage else { return }
        infoMessage = manager.add(image: image, name: imageName)
    }
    
    func removeFromCache() {
        infoMessage = manager.remove(name: imageName)
    }
    
    func getFromCache() {
        if let returnImage = manager.get(name: imageName) {
            cachedImage = returnImage
            infoMessage = "Got image From Cache"
            return
        } else {
            infoMessage = "Image Not founded"
        }
       
    }
}


struct CacheBootCamp: View {
    
    @StateObject var vm = CacheViewModel()
    
    var body: some View {
        NavigationView {
            
            VStack {
                
                if let image = vm.startingImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                
                Text(vm.infoMessage)
                    .font(.headline)
                    .foregroundColor(.purple)
                
                HStack {
                    Button {
                        vm.saveToCache()
                    } label: {
                        Text("Save to Cache")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                    Button {
                        vm.removeFromCache()
                    } label: {
                        Text("Delete ")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            
                            .cornerRadius(10)
                    }
                }
                Button {
                    vm.getFromCache()
                } label: {
                    Text("cache ")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        
                        .cornerRadius(10)
                }
                
                if let image = vm.cachedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                        .cornerRadius(10)
                }
                
                
                
                Spacer()
            }
        }
    }
}

struct CacheBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        CacheBootCamp()
    }
}
