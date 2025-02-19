//
//  CoreDataManager.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import CoreData
import UIKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    let persistentContainer: NSPersistentContainer

    private init() {
        persistentContainer = NSPersistentContainer(name: "RickMorty")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save: \(error)")
        }
    }

    func saveCharacters(_ characters: [Character]) {
        clearData()

        for character in characters {
            let entity = CharacterEntity(context: context)
            entity.id = Int64(character.id)
            entity.name = character.name
            entity.status = character.status
            entity.species = character.species
            entity.gender = character.gender
            entity.image = character.image
        }
        saveContext()
    }

    func fetchCharacters() -> [Character] {
        let request: NSFetchRequest<CharacterEntity> = CharacterEntity.fetchRequest()
        do {
            let entities = try context.fetch(request)
            return entities.map { Character(id: Int($0.id), name: $0.name!, status: $0.status!, species: $0.species!, gender: $0.gender!, image: $0.image!) }
        } catch {
            print("Failed to fetch characters: \(error)")
            return []
        }
    }

    func clearData() {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = CharacterEntity.fetchRequest()
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            saveContext()
        } catch {
            print("Failed to delete characters: \(error)")
        }
    }
}
