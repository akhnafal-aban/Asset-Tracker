//
//  Api.swift
//  Asset Tracker
//
//  Created by Noor Akhnafal Aban on 10/06/26.
//
 
import Foundation

struct Api {
    static func request(endpoint: String, method: HTTPMethod, body: Data? = nil) async throws -> Data {
        var request = URLRequest(url: URL(string: "\(AppConfig.baseURL)\(endpoint)")!)
        request.httpMethod = method.rawValue
        request.setValue(
            "application/json",
            forHTTPHeaderField: "Content-Type"
        )
        request.httpBody = body
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return data
    }
    
    static func send<T: Decodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        type: T.Type
    ) async throws -> T {
        let data = try await request(
            endpoint: endpoint,
            method: method,
        )

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(T.self, from: data)
    }
    
    static func send<T: Decodable, U: Encodable>(
        endpoint: String,
        method: HTTPMethod = .get,
        body: U? = nil,
        type: T.Type
    ) async throws -> T {

        let encodedBody: Data?
        
        if let body {
            let encoder = JSONEncoder()
            encoder.keyEncodingStrategy = .convertToSnakeCase
            encoder.dateEncodingStrategy = .iso8601
            
            encodedBody = try encoder.encode(body)
        } else {
            encodedBody = nil
        }
        
        let data = try await request(
            endpoint: endpoint,
            method: method,
            body: encodedBody
        )

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601

        return try decoder.decode(T.self, from: data)
    }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}
