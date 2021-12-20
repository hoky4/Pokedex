//
//  PokemonInfoViewController.swift
//  pokedex
//
//  Created by Kenny Ho on 12/16/21.
//

import UIKit

class PokemonInfoViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var typesLabel: UILabel!
    @IBOutlet var heightLabel: UILabel!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var hpLabel: UILabel!
    @IBOutlet var attackLabel: UILabel!
    @IBOutlet var defenseLabel: UILabel!
    @IBOutlet var spatkLabel: UILabel!
    @IBOutlet var spdefLabel: UILabel!
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var movesTextView: UITextView!

    var pokemon: Pokemon! {
        didSet {
            navigationItem.title = pokemon.name
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.layer.masksToBounds = true;
        imageView.layer.cornerRadius = 30
        
        imageView.image = UIImage(data: pokemon.image!.photo)
        self.typesLabel.text = "\(pokemon.pokemonType!.joined(separator: ", "))"
        self.heightLabel.text = "\(pokemon.height)"
        self.weightLabel.text = "\(pokemon.weight)"
        hpLabel.text = "\(pokemon.pokemonStats!["hp"]!)"
        attackLabel.text = "\(pokemon.pokemonStats!["attack"]!)"
        defenseLabel.text = "\(pokemon.pokemonStats!["defense"]!)"
        spatkLabel.text = "\(pokemon.pokemonStats!["special-attack"]!)"
        spdefLabel.text = "\(pokemon.pokemonStats!["special-defense"]!)"
        speedLabel.text = "\(pokemon.pokemonStats!["speed"]!)"
        movesTextView.text = "\(pokemon.pokemonMoves!.joined(separator: ", ")))"
    }

}

