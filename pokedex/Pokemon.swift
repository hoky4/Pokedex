//
//  Pokemon.swift
//  pokedex
//
//  Created by Kenny Ho on 12/14/21.
//

import Foundation
import UIKit

struct Pokedex: Decodable {
    let results: [PokedexResult]
}

struct PokedexResult: Codable {
    let name: String
    let url: URL?
}

class Pokemon: Codable {
    let id: Int
    let name: String
    let height: Int
    let weight: Int
    let types: [Types]
    var pokemonType: [String]?
    let sprites: Sprite
    var image: SomeImage?
    let stats: [Stats]
    var pokemonStats: [String: Int]?
    let moves: [Moves]
    var pokemonMoves: [String]?
}

struct Moves: Codable {
    let move: Move
}

struct Move: Codable {
    let name: String
}

struct Stats: Codable {
    let base_stat: Int
    let stat: Stat
}

struct Stat: Codable {
    let name: String
}

public struct SomeImage: Codable {

    public var photo: Data
    
    public init(photo: UIImage) {
        self.photo = UIImagePNGRepresentation(photo)!
    }
}

struct Sprite: Codable {
    let url: String?
    
    enum CodingKeys: String, CodingKey {
        case url = "front_default"
    }
}

struct Types: Codable {
    let type: PokemonType
}

struct PokemonType: Codable {
    let name: String
}

extension PokedexResult: Equatable {
    static func == (lhs: PokedexResult, rhs: PokedexResult) -> Bool {
        return lhs.name == rhs.name
    }
}
