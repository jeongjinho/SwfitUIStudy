//
//  WolframAlphaResult.swift
//  SwiftUIBoot
//
//  Created by jeong jinho on 2022/12/15.
//

import Foundation


struct WolframAlphaResult: Decodable {
  let queryresult: QueryResult

  struct QueryResult: Decodable {
    let pods: [Pod]

    struct Pod: Decodable {
      let primary: Bool?
      let subpods: [SubPod]

      struct SubPod: Decodable {
        let plaintext: String
      }
    }
  }
}

