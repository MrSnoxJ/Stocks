//
//  PersistenceManager.swift
//  Stocks
//
//  Created by Yerassyl Tynymbay on 14.12.2023.
//

import Foundation


final class PersistenceManager {
    static let shared = PersistenceManager()
    
    private let userDefaults : UserDefaults = .standard
    
    
    private struct Constants {
        static let unboardedKey = "hashOnboarded"
        static let watchlistKey = "watchlist"
    }
    
    private init () {}
    
    //CommentPublic
    
    public var watchlist : [String ] {
        if !hashOnboarded {
            userDefaults.setValue(true, forKey: Constants.unboardedKey)
            setUpDefaults()
        }
        return userDefaults.stringArray(forKey: Constants.watchlistKey) ?? []
    }
    
    public func addToWatchList () {
        
    }
    
    
    public func removeFromWatchList () {
        
    }
    //Comment Private
    
    private var hashOnboarded : Bool {
        return userDefaults.bool(forKey: Constants.unboardedKey)
    }
    
    
    private func setUpDefaults(){
        let map : [String : String] = [
            "AAPL" : "Apple Inc",
            "MSFT" : "Microsoft Corporation",
            "SNAP" : "Snap Inc",
            "GOOG" : "Alphabet",
            "AMZN" : "Amazon.com Inc",
            "WORK" : "Slack Technologies",
            "FB" : "Facebook Inc",
            "NVDA" : "Nvidia",
            "NKE" : "Nike",
            "PINS" : "Pinterest Inc"
        
        ]
        let symbols = map.keys.map{$0}
        userDefaults.set(symbols, forKey: Constants.watchlistKey)
        
        for(symbol,name ) in map {
            userDefaults.set(name,forKey: symbol)
        }
    }
}
