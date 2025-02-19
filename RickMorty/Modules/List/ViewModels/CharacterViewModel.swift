//
//  CharacterViewModel.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import Foundation
import Foundation
import Combine

class CharacterViewModel: ObservableObject {
    @Published var characters: [Character] = []
    @Published var isFetching: Bool = false
    @Published var errorMessage: String? = nil
    @Published var shouldShowRetry: Bool = false
    
    private var page = 1
    private var cancellables = Set<AnyCancellable>()

    func fetchCharacters() async {
            guard !isFetching else { return }
            isFetching = true
            errorMessage = nil
            shouldShowRetry = false

            do {
                let newCharacters = try await CharactersManager.shared.getCharacters(page: page)
                DispatchQueue.main.async {
                    self.characters.append(contentsOf: newCharacters)
                    CoreDataManager.shared.saveCharacters(self.characters)
                    self.page += 1
                    self.isFetching = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.characters = CoreDataManager.shared.fetchCharacters()
                    self.errorMessage = "Failed to fetch characters. Showing offline data."
                    self.shouldShowRetry = true
                    self.isFetching = false
                }
            }
        }

    func retryFetching() async {
        await fetchCharacters()
    }
    
    func refreshCharacters() {
        Task {
            do {
                let newCharacters = try await CharactersManager.shared.getCharacters(page: 1)
                DispatchQueue.main.async {
                    self.characters = newCharacters
                    CoreDataManager.shared.saveCharacters(self.characters)
                    self.page = 2  // Reset pagination
                    self.isFetching = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.characters = CoreDataManager.shared.fetchCharacters()
                    self.errorMessage = "Failed to refresh. Showing offline data."
                    self.isFetching = false
                }
            }

            DispatchQueue.main.async {
                NotificationCenter.default.post(name: NSNotification.Name("StopRefreshing"), object: nil)
            }
        }
    }
}
