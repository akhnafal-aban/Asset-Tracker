//
//  Api.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 10/06/26.
//

import Foundation

struct Api {
    private static func request(endpoint: String, method: String, body: Data? = nil) async throws -> Data {
        let url = URL(string: "\(AppConfig.baseURL)\(endpoint)")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method
        urlRequest.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        
        return data
    }
    
    static func get(endpoint: String) async throws -> Data {
        return try await request(endpoint: endpoint, method: "GET")
    }
    
    static func post(endpoint: String) async throws -> Data {
        return try await request(endpoint: endpoint, method: "POST")
    }
    
    static func put(endpoint: String) async throws -> Data {
        return try await request(endpoint: endpoint, method: "PUT")
    }
    
    static func patch(endpoint: String) async throws -> Data {
        return try await request(endpoint: endpoint, method: "PATCH")
    }
    
    static func delete(endpoint: String) async throws -> Data {
        return try await request(endpoint: endpoint, method: "DELETE")
    }
}
