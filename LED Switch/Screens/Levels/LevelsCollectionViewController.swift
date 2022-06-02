//
//  LevelsCollectionViewController.swift
//  LED Switch
//
//  Created by Lorin Budaca on 01.06.2022.
//

import UIKit

private let reuseIdentifier = "LevelCollectionViewCell"

class LevelsCollectionViewController: UICollectionViewController {
    
    private var levels = [Level]()

    override func viewDidLoad() {
        super.viewDidLoad()

        loadLevels()
    }
    
    private func loadLevels() {
        do {
            guard let url = Bundle.main.url(forResource: "Levels", withExtension: "json") else {
                print("Could not get levels bundle url")
                return
            }
            let data = try Data(contentsOf: url)
            let levels = try JSONDecoder().decode([Level].self, from: data)
            self.levels = levels
        } catch {
            print("Could not load levels", error)
        }
    }
    
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let destination = segue.destination as? GameViewController else {
            return
        }
        guard let cell = sender as? LevelCollectionViewCell, let level = cell.level else {
            return
        }
        destination.level = level
    }
    
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return levels.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! LevelCollectionViewCell
        
        cell.configure(level: levels[indexPath.row], color: .orange)
        
        return cell
    }
}
