//
//  LevelCollectionViewCell.swift
//  LED Switch
//
//  Created by Lorin Budaca on 01.06.2022.
//

import UIKit

class LevelCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var difficultyLabel: UILabel!
    @IBOutlet weak var trackLabel: UILabel!
    
    var level: Level?
    
    func configure(level: Level, color: UIColor) {
        self.level = level
        titleLabel.text = level.name
        difficultyLabel.text = level.difficulty.rawValue
        trackLabel.text = level.track.resource
        contentView.backgroundColor = color
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 20
    }
}
