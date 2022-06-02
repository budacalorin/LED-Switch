//
//  HighScoreManager.swift
//  LED Switch
//
//  Created by Lorin Budaca on 03.06.2022.
//

import Foundation

class HighScoreManager {
    static let shared = HighScoreManager()
    
    private init() { }
    
    func highScore(forLevel id: String) -> Int {
        return UserDefaults.standard.integer(forKey: id)
    }
    
    func setHighScore(forLevel id: String, newScore: Int) {
        return UserDefaults.standard.set(newScore, forKey: id)
    }
}
