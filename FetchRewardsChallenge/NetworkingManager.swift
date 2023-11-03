//
//  NetworkingManager.swift
//  FetchRewardsChallenge
//
//  Created by Akhil Anand Sirra on 01/11/23.
//

import Foundation

protocol GenericAPI {
    func getData<T: Decodable>(for: T.Type, endpoint: String) async throws -> T
}

final class NetworkingManager: GenericAPI {
    func getData<T: Decodable>(for: T.Type, endpoint: String) async throws -> T {
        
        guard let url = URL(string: endpoint) else {
            throw UserError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let response = response as? HTTPURLResponse, (200...300) ~= response.statusCode else {
            throw UserError.invalidResponse
        }
        
        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            
            return try decoder.decode(T.self, from: data)
        }
        catch {
            throw UserError.invalidData
        }
    }
}

// Error Handling cases
enum UserError: Error {
    case invalidURL
    case invalidResponse
    case invalidData
}
