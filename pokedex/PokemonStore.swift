//
//  PokemonStore.swift
//  pokedex
//
//  Created by Kenny Ho on 12/18/21.
//

import Foundation

class PokemonStore {
    var allPokemon = [Pokemon]()
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        return documentDirectory.appendingPathComponent("pokemon.plist")
    }()
    
    func save() {
        do {
            let encoder = PropertyListEncoder()
            let data = try encoder.encode(allPokemon)
            try data.write(to: itemArchiveURL, options: [.atomic])
         
        } catch let encodingError {
            print("Error encoding allPokemon: \(encodingError)")
     
        }
    }
    
    init() {
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let unarchiver = PropertyListDecoder()
            let pokemon = try unarchiver.decode([Pokemon].self, from: data)
            allPokemon = pokemon
        } catch {
            print("\nError reading in saved items: \(error)")
        }
    }
}
