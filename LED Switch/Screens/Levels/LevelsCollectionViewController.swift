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
//        levels = [
//            Level(
//                name: "Tutorial",
//                difficulty: .easy,
//                track: Track(
//                    resource: "C418 - Minecraft",
//                    extension: .mp3
//                ),
//                colorTargets: [
//                    ColorTarget(seconds: 100, color: UIColor.orange)
//                ]
//            ),
//            Level(
//                name: "Tutorial",
//                difficulty: .easy,
//                track: Track(
//                    resource: "C418 - Minecraft",
//                    extension: .mp3
//                ),
//                colorTargets: [
//                    ColorTarget(seconds: 100, color: UIColor.orange)
//                ]
//            ),
//            Level(
//                name: "Tutorial",
//                difficulty: .easy,
//                track: Track(
//                    resource: "C418 - Minecraft",
//                    extension: .mp3
//                ),
//                colorTargets: [
//                    ColorTarget(seconds: 100, color: UIColor.orange)
//                ]
//            ),
//            Level(
//                name: "Tutorial",
//                difficulty: .easy,
//                track: Track(
//                    resource: "C418 - Minecraft",
//                    extension: .mp3
//                ),
//                colorTargets: [
//                    ColorTarget(seconds: 100, color: UIColor.orange)
//                ]
//            )
//        ]
        
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
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
