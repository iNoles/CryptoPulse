//
//  Watchlist.swift
//  CryptoPulse
//
//  Created by Jonathan Steele on 7/4/25.
//

import SwiftUI

class Watchlist: ObservableObject {
    @Published private(set) var items: Set<String> = []
    private let key = "watchlist"
    
    init() {
        if let saved = UserDefaults.standard.array(forKey: key) as? [String] {
            items = Set(saved)
        }
    }
    
    func toggle(_ coinID: String) {
        if items.contains(coinID) {
            items.remove(coinID)
        } else {
            items.insert(coinID)
        }
        UserDefaults.standard.set(Array(items), forKey: key)
        objectWillChange.send()
    }
    
    func contains(_ coinID: String) -> Bool {
        items.contains(coinID)
    }
}

