//
//  BinanceWebSocketService.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 18/06/26.
//

import Foundation

//final class BinanceWebSocketService {
//    
//    private var webSocketTask: URLSessionWebSocketTask?
//    
//    var onPriceReceived: ((TradePrice) -> Void)?
//    
//    func connect() {
//        let url = URL(
//            string: "wss://stream.binance.com:443/ws/btcidr@trade"
//        )!
//        
//        webSocketTask =
//        URLSession.shared.webSocketTask(with: url)
//        
//        webSocketTask?.resume()
//        print("Connected to \(url)")
//        
//        receiveMessage()
//    }
//    
//    func disconnect() {
//        webSocketTask?.cancel(
//            with: .normalClosure,
//            reason: nil
//        )
//    }
//    
//    private func receiveMessage() {
//        webSocketTask?.receive { [weak self] result in
//            
//            switch result {
//                
//            case .success(let message):
//                
//                switch message {
//                    
//                case .string(let text):
//                    
//                    if let data = text.data(using: .utf8) {
//                        do {
//                            let trade =
//                            try JSONDecoder()
//                                .decode(
//                                    TradePrice.self,
//                                    from: data
//                                )
//                            
//                            self?.onPriceReceived?(trade)
//                            print("Data Received")
//                            
//                        } catch {
//                            print(error)
//                        }
//                    }
//                    
//                default:
//                    break
//                }
//                
//                self?.receiveMessage()
//                
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
//}

final class BinanceWebSocketService {
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    var onPriceReceived: ((TradePrice) -> Void)?
    
    func connect() {
        // Change btcidr to btcusdt because Binance delisted BIDR pairs in 2024.
        // btcidr will connect successfully but will never receive any trade data!
        let url = URL(string: "wss://stream.binance.com:443/ws/btcusdt@trade")!
        
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        
        webSocketTask?.resume()
        print("Connected to: \(url)")
        
        receiveMessage()
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
        print("Disconnected")
    }
    
    func receiveMessage() {
        print("Waiting for message ...")
        
        webSocketTask?.receive { [weak self] result in
            
            switch result {
                
            case .success(let message):
                
                print("Message received ...")
                
                switch message {
                    
                case .string(let text):
                    
                    print("Raw JSON:")
                    print(text)
                    
                    if let data = text.data(using: .utf8) {
                        do {
                            let trade = try JSONDecoder().decode(TradePrice.self, from: data)
                            
                            self?.onPriceReceived?(trade)
                        } catch {
                            print(error)
                        }
                    }
                    
                default:
                    break
                }
                
                // CRITICAL FIX: To continuously receive messages, you must call receiveMessage() again!
                self?.receiveMessage()
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
