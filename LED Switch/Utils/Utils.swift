//
//  Utils.swift
//  LED Switch
//
//  Created by Lorin Budaca on 01.06.2022.
//

import Foundation
import AVFoundation
import UIKit

extension CGFloat {
    func cappedBy(_ a: CGFloat, _ b: CGFloat) -> CGFloat{
        var a = a, b = b
        if !(a > b) { swap(&a, &b) }
        
        if self > a { return a }
        if self < b { return b }
        return self
    }
}

extension Array where Element == CGFloat {
    func sum() -> CGFloat {
        return reduce(0, +)
    }
}

extension UIColor {
    func getComponents() -> [CGFloat] {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return [red, green, blue, alpha]
    }
    
    func distance(to color: UIColor) -> CGFloat {
        return 255 * zip(self.getComponents(), color.getComponents())
            .map(-)
            .map(abs)
            .sum()
    }
}

extension AVAudioPlayer {
    convenience init?(from track: Track) {
        guard let url = Bundle.main.url(forResource: track.resource, withExtension: track.extension.rawValue) else {
            return nil
        }
        do {
            try self.init(contentsOf: url)
        } catch {
            print("Failed to load track", error)
            return nil
        }
    }
}
