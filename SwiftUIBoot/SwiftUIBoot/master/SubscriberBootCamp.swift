//
//  SubscriberBootCamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/08/30.
//

import SwiftUI
import Combine

class SubscriberViewModel: ObservableObject {
   
    @Published var count: Int = 0
    var timer: AnyCancellable?
    var cancellables = Set<AnyCancellable>()
    @Published var textFieldText: String = ""
    @Published var textIsValid: Bool = false
    @Published var showButton: Bool = false
    
    
    init() {
        setupTimer()
        addTextFieldSubscriber()
        addButtonSubscriber()
    }
    
    func addTextFieldSubscriber() {
        $textFieldText
           // .debounce(for: .second(0.5), scheduler: DispatchQueue.main)
            .map { text in
                return text.count > 3
            }
         //   .assign(to: \.textIsValid, on:  self)
            .sink(receiveValue: { [weak self] isValid in
                self?.textIsValid = isValid
            })
            .store(in: &cancellables)
    }
    
    func setupTimer() {
        Timer
            .publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.count += 1
                if let count = self?.count,
                   let cancellables = self?.cancellables,
                   count >= 10 {
//                    for item in  cancellables {
//                        item.cancel()
//                    }
                }
            }
            .store(in: &cancellables)
    }
    
    func addButtonSubscriber() {
        $textIsValid
            .combineLatest($count)
            .sink { [weak self] (isValid, count) in
                guard let self = self else { return }
                if isValid && count >= 10 {
                    self.showButton = true
                } else {
                    self.showButton = false
                }
            }
            .store(in: &cancellables)
    }
}

struct SubscriberBootCamp: View {
    
    @StateObject var vm = SubscriberViewModel()
    
    var body: some View {
        VStack {
            Text("\(vm.count)")
                .font(.largeTitle)
            
            Text(vm.textIsValid.description)
            
            TextField("type something here...", text: $vm.textFieldText)
                .padding(.leading)
                .frame(height: 55)
                .background(Color.gray)
                .cornerRadius(10)
                .overlay(
                    ZStack {
                        Image(systemName: "xmark")
                            .foregroundColor(.red)
                            .opacity(
                                vm.textFieldText.count < 1 ? 0.0 :
                                vm.textIsValid ? 0.0 : 1.0)
                        Image(systemName: "checkmark")
                            .foregroundColor(.green)
                            .opacity(vm.textIsValid ? 1.0 : 0.0)
                    }
                        .font(.title)
                        .padding(.trailing)
                    
                    , alignment: .trailing
                )
            
            Button(action: {}) {
                Text("Submit".uppercased())
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity )
                    .background(.blue)
                    .cornerRadius(10)
                    .opacity(vm.showButton ? 1.0 : 0.5)
            }
            .disabled(!vm.showButton)
            
            Text("hello")
                .frame(width: 100, height: 100, alignment: .leading)
                .background(
                    Circle()
                        .fill(.blue)
                    
                )
        }
        .padding()
     
    }
}

struct SubscriberBootCamp_Previews: PreviewProvider {
    static var previews: some View {
        SubscriberBootCamp()
    }
}
