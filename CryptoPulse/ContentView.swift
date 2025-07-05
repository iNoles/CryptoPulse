//
//  ContentView.swift
//  CryptoPulse
//
//  Created by Jonathan Steele on 7/4/25.
//

import SwiftUI
import Charts

struct ContentView: View {
    @StateObject var api = CoinGeckoAPI()
    @StateObject var watchlist = Watchlist()
    
    var body: some View {
        NavigationView {
            List(api.coins) { coin in
                HStack {
                    AsyncImage(url: URL(string: coin.image)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 32, height: 32)
                    
                    VStack(alignment: .leading) {
                        Text(coin.name)
                            .font(.headline)
                        Text(coin.symbol.uppercased())
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing) {
                        Text("$\(coin.current_price, specifier: "%.2f")")
                            .bold()
                        if let change = coin.price_change_percentage_24h {
                            Text("\(change >= 0 ? "+" : "")\(change, specifier: "%.2f")%")
                                .foregroundColor(change >= 0 ? .green : .red)
                                .font(.caption)
                        }
                    }
                    
                    Button(action: {
                        watchlist.toggle(coin.id)
                    }) {
                        Image(systemName: watchlist.contains(coin.id) ? "star.fill" : "star")
                            .foregroundColor(.yellow)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
                .padding(.vertical, 4)
                .background {
                    if let prices = coin.sparkline_in_7d?.price {
                        Chart {
                            ForEach(Array(prices.enumerated()), id: \.offset) { index, price in
                                LineMark(
                                    x: .value("Day", index),
                                    y: .value("Price", price)
                                )
                            }
                        }
                        .chartYAxis(.hidden)
                        .chartXAxis(.hidden)
                        .frame(height: 40)
                    }
                }
            }
            .navigationTitle("CryptoPulse")
            .toolbar {
                Button("Refresh") {
                    api.fetchCoins()
                }
            }
            .onAppear {
                api.fetchCoins()
            }
            .refreshable {
                api.fetchCoins()
            }
        }
    }
}


#Preview {
    ContentView()
}
