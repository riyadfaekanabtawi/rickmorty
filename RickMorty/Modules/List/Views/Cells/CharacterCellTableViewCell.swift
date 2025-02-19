//
//  CharacterCellTableViewCell.swift
//  RickMorty
//
//  Created by Riyad Anabtawi on 12/02/25.
//

import UIKit
import SDWebImage

class CharacterCellTableViewCell: UITableViewCell {

    @IBOutlet weak var characterNameLabel: UILabel!
    @IBOutlet weak var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func configure(_ character: Character?) {
        
        characterNameLabel.text = character?.name
        characterImageView.sd_setImage(with: URL(string: character?.image ?? ""), completed: nil)
    }
}
