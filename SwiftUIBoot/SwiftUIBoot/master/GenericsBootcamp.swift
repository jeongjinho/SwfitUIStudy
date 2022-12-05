//
//  GenericsBootcamp.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/11/09.
//

import SwiftUI

struct StringModel {
    let info: String?
    func removeInfo() -> StringModel {
        return StringModel(info: nil)
    }
}

struct BoolModel {
    let info: Bool?
    func removeInfo() -> BoolModel {
        return BoolModel(info: nil)
    }
}

struct GenericModel<CustomType> {
    
    let info: CustomType?
    func removeInfo() -> GenericModel {
        return GenericModel(info: nil)
    }
}


class GenericsViewModel: ObservableObject {
    
    @Published var stringModel: StringModel = StringModel(info: "Hello, world!")
    @Published var boolModel: BoolModel = BoolModel(info: true)
    @Published var genericStringModel: GenericModel = GenericModel(info: "Hello, world!")
    
    @Published var genericBoolModel: GenericModel = GenericModel(info: true)
    init() {
       // dataArray = [false, false, true]
    }
    
    func removeData() {
        stringModel = stringModel.removeInfo()
        boolModel = boolModel.removeInfo()
        genericStringModel = genericStringModel.removeInfo()
        genericBoolModel = genericBoolModel.removeInfo()
    }
}

struct GenericView<CustomType: View>: View {
    let content: CustomType
    let title: String
    
    var body: some View {
        Text(title)
        content
    }
}

struct GenericsBootcamp: View {
    
    @StateObject private var vm = GenericsViewModel()
    var body: some View {
        VStack {
            
            GenericView(content: Text("custom Contents"), title: "new View")
            
            Text(vm.stringModel.info ?? "no data")
                .onTapGesture {
                    vm.removeData()
                }
            
            Text(vm.boolModel.info?.description ?? "no data")
                .onTapGesture {
                    vm.removeData()
                }
            
            Text(vm.genericStringModel.info ?? "no data")
                .onTapGesture {
                    vm.removeData()
                }
            
            Text(vm.genericBoolModel.info?.description ?? "no data")
                .onTapGesture {
                    vm.removeData()
                }
        }
        

    }
}

struct GenericsBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        GenericsBootcamp()
    }
}
