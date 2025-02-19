//
//  CharacterManager.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation

class CharactersManager {
    static let shared = CharactersManager(apiManager: APIManager.shared)

    private let apiManager: APIManagerProtocol

    init(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }
    
    func getCharacters(page: Int) async throws -> [Character] {
        return try await apiManager.request(apiRequest: CharactersRequests.fetchCharacters(page: page)).results
    }
}
