//
//  XMarkButton.swift
//  SwiftfulCripto
//
//  Created by jeong jinho on 2022/09/27.
//

import SwiftUI

struct XMarkButton: View {
    let dismiss: DismissAction
    var body: some View {
        Button(action: {
            dismiss()
        }, label: {
            Image(systemName: "xmark")
                .font(.headline)
        }
        )
    }
}

struct XMarkButton_Previews: PreviewProvider {
    @Environment(\.dismiss) static private var dismiss
    static var previews: some View {
        XMarkButton(dismiss: dismiss)
    }
}
