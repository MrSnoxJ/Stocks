//
//  SearchRespons.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 14.12.2023.
//

import Foundation
struct SearchRespons : Codable {
    let count : Int
    let result: [SearchResults]
}
struct SearchResults : Codable {
    let description : String
    let displaySymbol: String
    let symbol: String
    let type: String
    
    
}
