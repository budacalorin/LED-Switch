//
//  ColorTarget.swift
//  LED Switch
//
//  Created by Lorin Budaca on 01.06.2022.
//

import Foundation
import UIKit

class ColorTarget: Decodable {
    
    let seconds: TimeInterval
    
    let color: UIColor
    
    init(seconds: TimeInterval, color: UIColor) {
        self.seconds = seconds
        self.color = color
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let seconds = try container.decode(Double.self, forKey: .seconds)
        let color = try container.decode(Dictionary<String, Double>.self, forKey: .color)
        
        let red = color["red"] ?? 0
        let green = color["green"] ?? 0
        let blue = color["blue"] ?? 0
        
        self.seconds = seconds
        self.color = UIColor(displayP3Red: red, green: green, blue: blue, alpha: 1)
    }
    
    private enum CodingKeys: CodingKey {
        case seconds
        case color
        case red
        case green
        case blue
    }
}
