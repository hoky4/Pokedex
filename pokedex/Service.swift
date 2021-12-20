//
//  Service.swift
//  pokedex
//
//  Created by Kenny Ho on 12/18/21.
//

import UIKit

class Service {
    
    static let shared = Service()
    let BASE_URL = "https://pokeapi.co/api/v2/pokemon/?limit=151"
    
    func fetchPokemon(completion: @escaping ([Pokemon]) -> ()) {
        var pokemonArray = [Pokemon]()
        
        guard let url = URL(string: BASE_URL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // handle error
            if let error = error {
                print("Failed to fetch data with error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
                let resultArray = try decoder.decode(Pokedex.self, from: data)

                let group = DispatchGroup()
                for result in resultArray.results {
                    group.enter()
                    self.fetchPokemon(for: result, completion: {
                        (pokemon) in
                        let currentPokemon = pokemon
                        
                        // parse types
                        var types = [String]()
                        for type in pokemon.types {
                            types.append(type.type.name)
                        }
                        currentPokemon.pokemonType = types
                        
                        //parse stats
                        var stats = [String: Int]()
                        for stat in pokemon.stats {
                            stats[stat.stat.name] = stat.base_stat
                        }
                        currentPokemon.pokemonStats = stats

                        // parse moves
                        var moves = [String]()
                        for move in pokemon.moves {
                            moves.append(move.move.name)
                        }
                        currentPokemon.pokemonMoves = moves                        
                        
                        self.fetchImage(withUrlString: pokemon.sprites.url!) {
                            (image) in
                            defer { group.leave() }

                            let pokemonImage = SomeImage(photo: image)
                            currentPokemon.image = pokemonImage
                            pokemonArray.append(currentPokemon)
                        }
                    })
                }
                group.notify(queue: .main) {
                    pokemonArray.sort(by: { $0.id < $1.id
                    })
                    completion(pokemonArray)
                }
            } catch let error {
                print("Failed to create json with error: ", error.localizedDescription)
            }
        }.resume()
    }
    
    func fetchPokemon(for result: PokedexResult, completion: @escaping (Pokemon) -> Void) {
        guard let pokedexURL = result.url else { return }
        
        let request = URLRequest(url: pokedexURL)
        
        URLSession.shared.dataTask(with: request) {
            (data, response, error) in

            do {
                let decoder = JSONDecoder()
                let pokemonResponse = try decoder.decode(Pokemon.self, from: data!)
        
                completion(pokemonResponse)
            } catch let error {
                print("Failed to create pokemon with error: ", error.localizedDescription)
            }
        }.resume()
    }
    
    private func fetchImage(withUrlString urlString: String, completion: @escaping(UIImage) -> ()) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if let error = error {
                print("Failed to fetch image with error: ", error.localizedDescription)
                return
            }
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else { return }
            completion(image)
            
        }.resume()
    }
}
