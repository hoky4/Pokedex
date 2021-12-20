//
//  ViewController.swift
//  pokedex
//
//  Created by Kenny Ho on 12/14/21.
//

import UIKit

class ViewController: UICollectionViewController {

    var pokemonStore: PokemonStore!
    var filteredPokemon = [Pokemon]()
    var allPokemonTypes = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Pokedex"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(filterTapped))

//        pokemonStore.allPokemon = [Pokemon]()
        if pokemonStore.allPokemon.isEmpty {
            print("\nFetching pokemon from pokeAPI...")
            fetchPokemon()
        } else {
            print("\nLoading pokemon from disk")
            filteredPokemon = pokemonStore.allPokemon
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredPokemon.count

    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Pokemon", for: indexPath) as! PokemonCollectionViewCell
        
        let pokemon = filteredPokemon[indexPath.item]

        cell.updateName(displaying: "\(pokemon.name)")
        cell.updateId(displaying: "\(pokemon.id)")

        cell.update(displaying: UIImage(data: pokemon.image!.photo))

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "showPokemon":
            if let selectedIndexPath = collectionView?.indexPathsForSelectedItems?.first {
                let selectedPokemon = filteredPokemon[selectedIndexPath.item]
                let destinationVC = segue.destination as! PokemonInfoViewController
                destinationVC.pokemon = selectedPokemon
            }
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    @objc func filterTapped() {
        let ac = UIAlertController(title: "Choose Filter", message: nil, preferredStyle: .actionSheet)

        for filter in ["Number", "Name", "Type"] {
            ac.addAction(UIAlertAction(title: filter, style: .default, handler: filterPokemon))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func typeTapped() {
        let ac = UIAlertController(title: "Choose Type", message: nil, preferredStyle: .actionSheet)
        
        if allPokemonTypes.isEmpty {
            getAllTypes()
        }

        for type in allPokemonTypes {
            ac.addAction(UIAlertAction(title: type, style: .default, handler: filterByType))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func filterByType(action: UIAlertAction) {
        let type = action.title!
        filteredPokemon = pokemonStore.allPokemon.filter { $0.pokemonType?.contains(type) as! Bool }
        self.collectionView?.reloadData()

    }
    func filterPokemon(action: UIAlertAction) {
        let filter = action.title!
        
        switch filter {
        case "Number":
            filteredPokemon = pokemonStore.allPokemon.sorted(by: { $0.id < $1.id })
            self.collectionView?.reloadData()
        case "Name":
            filteredPokemon = pokemonStore.allPokemon.sorted(by: { $0.name < $1.name })
            self.collectionView?.reloadData()
        case "Type":
            typeTapped()
        default:
            print("No matching case")
        }
    }
    
    func getAllTypes() {
        var types = [String]()
        for pokemon in pokemonStore.allPokemon {
            for type in pokemon.pokemonType! {
                if !types.contains(type) {
                    types.append(type)
                }
            }
        }
        allPokemonTypes = types
    }
    
    func fetchPokemon() {
        Service.shared.fetchPokemon { (pokemon) in
            DispatchQueue.main.async {
                // save pokemon to disk
                self.pokemonStore.allPokemon = pokemon
                self.filteredPokemon = pokemon
                self.pokemonStore.save()
                self.collectionView?.reloadData()
            }
        }
    }
}

