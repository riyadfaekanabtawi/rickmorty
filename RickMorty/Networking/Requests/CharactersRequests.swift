//
//  CharactersRequests.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation

struct CharactersRequests {
    static func fetchCharacters(page: Int) -> APIRequest<String, CharacterResponse> {
        return .init(
            method: .get,
            endpoint: "character/",
            queryParams: ["page": "\(page)"]
        )
    }
}
