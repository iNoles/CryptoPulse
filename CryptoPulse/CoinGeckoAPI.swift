//
//  CoinGeckoAPI.swift
//  CryptoPulse
//
//  Created by Jonathan Steele on 7/4/25.
//

import Foundation
import Combine

class CoinGeckoAPI: ObservableObject {
    @Published var coins: [Coin] = []
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchCoins() {
        let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page=1&sparkline=true"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Coin].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    print("Error fetching coins: \(error)")
                }
            }, receiveValue: { [weak self] coins in
                self?.coins = coins
            })
            .store(in: &cancellables)
    }
}

