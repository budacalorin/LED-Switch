//
//  Level.swift
//  LED Switch
//
//  Created by Lorin Budaca on 01.06.2022.
//

import Foundation

struct Level: Decodable {
    
    let id: String
    let name: String
    let difficulty: Difficulty
    let track: Track
    let colorTargets: [ColorTarget]
    
    init(
        id: String,
        name: String,
        difficulty: Difficulty,
        track: Track,
        colorTargets: [ColorTarget]
    ) {
        self.id = id
        self.name = name
        self.difficulty = difficulty
        self.track = track
        self.colorTargets = colorTargets.sorted {
            $0.seconds < $1.seconds
        }
    }
    
}
