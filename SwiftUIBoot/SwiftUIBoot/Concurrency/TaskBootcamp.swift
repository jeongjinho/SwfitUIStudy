//
//  TaskBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/10/31.
//

import SwiftUI

class TaskBootcampViewModel: ObservableObject {
    
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    func fetchImage() async {
        try? await Task.sleep(5_000_000_000)
        
        
//        for x in array {
////          try  Task.checkCancellation()/
//        }
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            
            let (data, _ ) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image = UIImage(data: data)
                print("Task to Success!")
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func fetchImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else { return }
            
            let (data, _ ) = try await URLSession.shared.data(from: url)
            await MainActor.run {
                self.image2 = UIImage(data: data)
                print("Task to Success!")
            }
            
            
        } catch {
            print(error.localizedDescription)
        }
    }
}


struct TaskBootcampHomeView: View {
    
    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink("ClICK ME!") {
                    TaskBootcamp()
                }
            }
        }
    }
}


struct TaskBootcamp: View {
   @State private  var task: Task<(), Never>? = nil
    @StateObject private var viewModel = TaskBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40) {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
            
            if let image = viewModel.image2 {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 200, height: 200)
            }
        }
        
        .task {
            await viewModel.fetchImage()
        }
//        .onDisappear {
//            self.task?.cancel()
//        }
//        .onAppear {
//
//            self.task = Task {
//
//                await viewModel.fetchImage()
//            }
            
            
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage()
//            }
//            Task {
//                print(Thread.current)
//                print(Task.currentPriority)
//                await viewModel.fetchImage2()
//            }
//            Task(priority: .high) {
//                //try? await Task.sleep(2_000_000_000)
//               await Task.yield()
//                print("high: \(Thread.current): \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current): \(Task.currentPriority)")
//            }
//
//            Task(priority: .medium) {
//                print("medium: \(Thread.current): \(Task.currentPriority)")
//            }
//            Task(priority: .low) {
//                print("LOW: \(Thread.current): \(Task.currentPriority)")
//            }
//            Task(priority: .utility) {
//                print("utility: \(Thread.current): \(Task.currentPriority)")
//            }
//
//            Task(priority: .background) {
//                print("background: \(Thread.current): \(Task.currentPriority)")
//            }
            
//            Task(priority: .userInitiated) {
//                print("userInitiated: \(Thread.current): \(Task.currentPriority)")
//
//                Task.detached {
//                    print("userInitiated2: \(Thread.current): \(Task.currentPriority)")
//                }
//
//            }
    //    }
        
        ScrollViewReader { proxy in
            
            
        }
    }
}

struct TaskBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        TaskBootcamp()
    }
}
