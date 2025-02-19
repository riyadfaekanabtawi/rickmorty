//
//  APIManagerProtocol.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation

protocol APIManagerProtocol {
    func request<T: Codable, U: Codable>(
        apiRequest: APIRequest<T, U>
    ) async throws -> U
}
