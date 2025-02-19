//
//  CharacterModel.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation

struct CharacterResponse: Codable {
    let results: [Character]
}

struct Character: Codable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let gender: String
    let image: String
}
