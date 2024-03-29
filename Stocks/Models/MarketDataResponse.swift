//
//  MarketDataResponse.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 15.12.2023.
//

import Foundation
struct MarketDataResponse : Codable {
    let open : [Double]
    let close : [Double]
    let high : [Double]
    let low : [Double]
    let status : String
    let timestamps : [TimeInterval]
    
    enum CodingKeys : String, CodingKey {
        case open = "o"
        case low = "l"
        case close = "c"
        case high = "h"
        case status = "s"
        case timestamps = "t"
    }
    
    var candleSticks: [CandleStick] {
        var result = [CandleStick]()
        
        for index in 0..<open.count {
            result.append(.init(date: Date(timeIntervalSince1970: timestamps[index]), high: high[index], low: low[index], open: open[index], close: close[index]))
        }
        let sortedData = result.sorted(by: { $0.date > $1.date})
        
        return sortedData
    }
}
struct CandleStick {
    let date : Date
    let high : Double
    let low : Double
    let open : Double
    let close : Double
}
