//
//  StructClassActorBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/21.
//

import SwiftUI

struct StructClassActorBootcamp: View {
    var body: some View {
        
        Text("Hello World!")
            .onAppear {
                runTest()
            }
        
    }
}

struct MyStruct {
    var title: String
    
}

class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
}


struct StructClassActorBootcamp_preview: PreviewProvider {
    static var previews: some View {
        StructClassActorBootcamp()
    }
}

extension StructClassActorBootcamp {
    private func runTest() {
        print("Test started!")
        classTest1()
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting title!")
        print("ObjectA ", objectA.title)
        
        var objectB = objectA
        print("ObjectB ", objectB.title)
        
        objectB.title = "Second title!"
         
        print("ObjectA ", objectA.title)
        print("ObjectB ", objectB.title)
        
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "Starting Title")
        
        print("ObjectA ", objectA.title)
        
        var objectB = objectA
        print("ObjectB ", objectB.title)
        
        objectB.title = "Second title!"
         
        print("ObjectA ", objectA.title)
        print("ObjectB ", objectB.title)
    }
}
