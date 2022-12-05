//
//  CheckContinuationBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/09.
//

import SwiftUI

class CheckedContinuationBootcampNetworkManager {
    
    func getData(url: URL) async throws -> Data {
        do {
          let (data, response) = try await URLSession.shared.data(from: url)
            return data
        } catch {
            throw error
        }
    }
    
    func getData2(url: URL) async throws -> Data {
        
        
       return try await withCheckedThrowingContinuation {  continuation  in
           URLSession.shared.dataTask(with: url) { data, response, error in
               if let data = data {
                   continuation.resume(returning: data)
               } else if let error {
                   continuation.resume(throwing: error )
               } else {
                   continuation.resume(throwing: URLError(.badURL))
               }
               
           }.resume()
        }
        
    }
    
    func getHeartImageFromeDatabase(completionHandler:  @escaping (_ image: UIImage ) -> ())  {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            completionHandler(UIImage(systemName: "heart.fill")!)
        }
    }
    
    func getHeartImageFromeDatabase() async -> UIImage {
        await withCheckedContinuation({ continuation in
            
            getHeartImageFromeDatabase { image in
                continuation.resume(returning: image)
            }
        })
    }
}


class CheckedContinuationBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    let networkManager = CheckedContinuationBootcampNetworkManager()
    
    func getImage() async {
        guard let url  = URL(string: "https://picsum.photos/300") else { return }
        do {
            let data = try  await networkManager.getData2(url: url)
            if let image = UIImage(data: data) {
                await MainActor.run(body: {
                    self.image = image
                })
            }
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func getHeartImage() async {
        
        networkManager.getHeartImageFromeDatabase { [weak self] image in
            self?.image = image
        }
    }
    
    func getHeartImage2() async {
        
     let image = await networkManager.getHeartImageFromeDatabase()
        self.image = image
    }
}


struct CheckContinuationBootcamp: View {
    
    @StateObject private var viewModel = CheckedContinuationBootcampViewModel()
    
    var body: some View {
        ZStack {
            
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
                
            }
        }
        .task {
//            await viewModel.getImage()//
            await viewModel.getHeartImage2()
        }
    }
}

struct CheckContinuationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CheckContinuationBootcamp()
    }
}
