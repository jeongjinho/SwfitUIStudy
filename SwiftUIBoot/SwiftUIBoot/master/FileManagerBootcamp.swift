//
//  FileManagerBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/09/13.
//


import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    let folderName = "MyApp_Images"
    func saveImage(image: UIImage, name: String) -> String {
        
        guard let data = image.jpegData(compressionQuality: 1.0),
              let path = getPathForImage(name: name)
        else {
            print("Error getting data.")
            return "Error getting data."
            
        }
        
//       // let directory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        let directory2 = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first
//     //   let directory3 = FileManager.default.temporaryDirectory
//
//        let path = directory2?.appendingPathComponent("\(name).jpg")
//        print(directory2)
//        print(path)
        
       
       
        do {
         try data.write(to: path)
            print(path)
            return "Success  saving!"
        } catch let error {
            print("Error savin. \(error)")
            return "Error saving \(error)"
        }
         
    }
    
    
    init() {
        createFolderIfNeeded()
    }
    
    func createFolderIfNeeded() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .path else { return }
        
        if !FileManager.default.fileExists(atPath: path) {
            do {
                try FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true)
                print("Success creating folder")
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
    
    func deleteFolder() {
        guard let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .path else { return }
        
        do {
            try FileManager.default.removeItem(atPath: path)
            print("Success Deleting folder")
        } catch let error {
            print("Error Deleting Folder")
        }
    }
    
    func getImage(name: String) -> UIImage? {
        
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("Error getting path.")
            return nil
            
        }

        return UIImage(contentsOfFile: path)
    }
    
    func getPathForImage(name: String) -> URL? {
        guard let path = FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
            .appendingPathComponent("\(name).jpg") else {
            return nil
            
        }
        
        return path
    }
    
    func deleteImage(name: String) -> String {
        guard
            let path = getPathForImage(name: name)?.path,
            FileManager.default.fileExists(atPath: path) else {
            print("Error getting path.")
            return "Error getting path."
            
        }
        
        do {
            try FileManager.default.removeItem(atPath: path)
           return "Success Deleting"
        } catch let error {
            return "Error deleting path. \(error)"
        }
    }
}


class FileManagerViewModel: ObservableObject {

    let imageName: String = "steve-jobs"
    
    @Published var image: UIImage? = nil
    @Published var infoMessage: String = ""
    
    let manager = LocalFileManager.instance
    init() {
//        getImageFromFileManager()
        getImageFromAssetsFolder()
        
    }
    
    
    func getImageFromFileManager() {
        image = manager.getImage(name: imageName)
    }
    
    func getImageFromAssetsFolder() {
    
        image = UIImage(named: imageName)
    }
    
    func saveImage() {
        guard let image = image else {
            return
        }

        infoMessage = manager.saveImage(image: image, name: imageName)
    }
    
    func deleteImage() {
        infoMessage = manager.deleteImage(name: imageName)
        manager.deleteFolder()
    }
}

struct FileManagerBootCamp: View {
    
    @StateObject var vm = FileManagerViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                if let image = vm.image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 200, height: 200)
                        .clipped()
                    .cornerRadius(10)
                }
                
                HStack {
                    Button {
                        vm.saveImage()
                    } label: {
                        Text("Save to FM")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.blue)
                            .cornerRadius(10)
                            
                    }
                    Button {
                        vm.deleteImage()
                    } label: {
                        Text("delete from FM")
                            .foregroundColor(.white)
                            .font(.headline)
                            .padding()
                            .padding(.horizontal)
                            .background(Color.red)
                            .cornerRadius(10)
                            
                    }
                }
               
                Text(vm.infoMessage)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .foregroundColor(.purple)

            Spacer()
                
            }
            .navigationTitle("File Manager")
        }
    }
}


struct FileManagerBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FileManagerBootCamp()
    }
}
