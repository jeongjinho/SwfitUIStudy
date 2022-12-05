//
//  AsyncAwaitBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/10/27.
//

import SwiftUI

class AsyncAwaitBootcampViewModel :ObservableObject {
    
    @Published var dataArray: [String] = []
    
//    func addTitle1() {
//        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//            self.dataArray.append("\(Thread.current)")
//        }
//
//    }
//
//    func addTitle2() {
//        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
//            let title = "T: \(Thread.current)"
//            DispatchQueue.main.async {
//                self.dataArray.append(title)
//                let title3 = "T: \(Thread.current)"
//                self.dataArray.append(title3)
//            }
//
//        }
//
//    }
    
    func addAuthor1()  async {
        let author1 = "Author1: \(Thread.current)"
        self.dataArray.append(author1)
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let author2 = "Author2: \(Thread.current)"
        
        await MainActor.run(body: {
            self.dataArray.append(author2)
            
            let author3 = "Author3: \(Thread.current)"
            self.dataArray.append(author3)
        })
        
        await doSomething()
       
    }
    
    
    func doSomething() async {
        print("HI")
        
        try? await Task.sleep(nanoseconds: 2_000_000_000)
        
        let something1 = "something1: \(Thread.current)"
        
        await MainActor.run(body: {
            self.dataArray.append(something1)
            
            let something2 = "something2: \(Thread.current)"
            self.dataArray.append(something2)
        })
    }
}

struct AsyncAwaitBootcamp: View {
    
    @StateObject private var viewModel: AsyncAwaitBootcampViewModel = AsyncAwaitBootcampViewModel()
    
    var body: some View {
        List {
            ForEach(viewModel.dataArray, id:\.self) { data in
                Text(data)
            }
            
        }
        .onAppear {
            Task {
               await viewModel.addAuthor1()
                let fialText = "FINAL TEXT: \(Thread.current)"
                viewModel.dataArray.append(fialText)
            }
//            viewModel.addTitle1()
//            viewModel.addTitle2()
        }
    }
}

struct AsyncAwaitBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AsyncAwaitBootcamp()
    }
}
