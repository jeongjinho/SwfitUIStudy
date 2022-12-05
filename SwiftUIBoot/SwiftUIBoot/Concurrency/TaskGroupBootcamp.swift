//
//  TaskGroupBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/04.
//

import SwiftUI

class TaskGroupBootcampDataMananger {
    
    func fetchImageWithAsyncLet() async throws -> [UIImage] {
        async let fetchImage1 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage2 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage3 = fetchImage(urlString: "https://picsum.photos/200")
        async let fetchImage4 = fetchImage(urlString: "https://picsum.photos/200")
        
        let (image1, image2, image3, image4) = await (try fetchImage1, try fetchImage2, try fetchImage3, try fetchImage4)
        return [image1, image2, image3, image4]
    }
    
    
    func fetchImage(urlString: String) async  throws -> UIImage {
        guard let url = URL(string: urlString) else { throw URLError(.badURL) }
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            if let image = UIImage(data: data) {
                return image
            } else {
                throw URLError(.badURL)
            }
        } catch let error {
            throw error
        }
    }
    
    func fetchImagesWithTaskGroup() async throws -> [UIImage] {
        let urlStrings = [
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300",
            "https://picsum.photos/300"
            
        ]
        
        
      return try await withThrowingTaskGroup(of: UIImage?.self) { group in
          var images: [UIImage] = []
          images.reserveCapacity(urlStrings.count)
          for urlString in urlStrings {
              group.addTask {
                  try? await self.fetchImage(urlString: urlString)
                  
              }
          }
          
          for try await image in group {
              if let image {
                  images.append(image)
              }
             
          }
           
           return images
        }
    }
}

class TaskGroupBootcampViewModel: ObservableObject {
    @Published  var images: [UIImage] = []
    let manager = TaskGroupBootcampDataMananger()
    
    func getImages() async {
        if let image =  try? await manager.fetchImagesWithTaskGroup() {
            self.images.append(contentsOf: image)
        }
    }
    
    
}

struct TaskGroupBootcamp: View {
    @StateObject private var viewModel = TaskGroupBootcampViewModel()
    
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
   
    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(viewModel.images, id: \.self) { image in
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(height: 150)
                        
                    }
                }
            }
            .navigationTitle("Async Let Bootcamp")
            .task {
                await viewModel.getImages()
            }
        }
    }
}

struct TaskGroupBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskGroupBootcamp()
    }
}
