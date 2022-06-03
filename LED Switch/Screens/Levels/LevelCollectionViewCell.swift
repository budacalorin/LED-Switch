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
    @IBOutlet weak var highScoreLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var level: Level?
    
    func configure(level: Level) {
        self.level = level
        titleLabel.text = level.name
        difficultyLabel.text = level.difficulty.rawValue
        trackLabel.text = level.track.resource
        let highScore = HighScoreManager.shared.highScore(forLevel: level.id)
        highScoreLabel.isHidden = highScore == 0
        imageView.image = UIImage(named: level.image)
        if highScore > 0 {
            highScoreLabel.text = "High Score: \(highScore)"
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.layer.cornerRadius = 20
    }
}
