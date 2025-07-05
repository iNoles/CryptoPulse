//
//  Coin.swift
//  CryptoPulse
//
//  Created by Jonathan Steele on 7/4/25.
//

import Foundation

struct Coin: Identifiable, Codable {
    let id: String
    let symbol: String
    let name: String
    let image: String
    let current_price: Double
    let price_change_percentage_24h: Double?
    let sparkline_in_7d: Sparkline?
    
    struct Sparkline: Codable {
        let price: [Double]
    }
}

