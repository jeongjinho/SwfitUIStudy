//
//  FuturesBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/05.
//

import SwiftUI
import Combine
class FuturesBootcampViewModel: ObservableObject {
    
    @Published var title: String = "Staring Title"
    var cancellables = Set<AnyCancellable>()
    let url = URL(string: "https://www.google.com")!
    
    init() {
        download()
    }
    
    func download() {
//        getCombinePublisher()
//            .sink { _ in
//
//            } receiveValue: { [weak self] returnedValue in
//                self?.title = returnedValue
//            }
//            .store(in: &cancellables)
//        getEscapingClosure {[weak self] value, error in
//            self?.title = value
//          }
        
        getFuturePublisher()
        
            .sink { _ in
                
            } receiveValue: { [weak self] returnedValue in
                self?.title = returnedValue
            }
            .store(in: &cancellables)
    }
    
    func getCombinePublisher() -> AnyPublisher<String, URLError> {
        
        URLSession.shared.dataTaskPublisher(for: self.url)
            .timeout(1, scheduler: DispatchQueue.main)
            .map({ _ in
                return "new Value"
            })
            .eraseToAnyPublisher()
    }
    
    func getEscapingClosure(handler: @escaping (_ value: String, _ error: Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            handler("newVaule 2", nil)
        }
        .resume()
    }
    
    func getFuturePublisher()  -> Future<String, Error> {
        
        
        return Future { promise in
            self.getEscapingClosure { value, error in
                if let error {
                    promise(.failure(error))
                } else {
                    promise(.success(value))
                }
            }
        }
    }
    
    func doSomething(completionHandler: @escaping (_ value: String) -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            completionHandler("new str!")
        }
    }
    
    func doSomethingInFuture() -> Future<String, Never> {
        
        Future { promise in
            self.doSomething { value in
                promise(.success(value))
            }
            
        }
    }
}


struct FuturesBootcamp: View {
    @StateObject private var vm = FuturesBootcampViewModel()
    var body: some View {
        Text(vm.title)
    }
}

struct FuturesBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        FuturesBootcamp()
    }
}
