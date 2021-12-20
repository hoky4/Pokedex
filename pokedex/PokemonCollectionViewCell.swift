//
//  PokemonCollectionViewCell.swift
//  pokedex
//
//  Created by Kenny Ho on 12/16/21.
//

import UIKit

class PokemonCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var id: UILabel!

//    @IBOutlet var spinner: UIActivityIndicatorView!
    
    func updateName(displaying name: String) {
        self.name.text = name
    }
    
    func updateId(displaying id: String) {
        self.id.text = id
    }
    
    func update(displaying image: UIImage?) {
        imageView.image = image

    }
    
    override func layoutSubviews() {
        self.layer.cornerRadius = 10
        id.layer.masksToBounds = true
        id.layer.cornerRadius = 5
    }
    
    
}
