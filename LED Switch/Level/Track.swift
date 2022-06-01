//
//  Track.swift
//  LED Switch
//
//  Created by Lorin Budaca on 01.06.2022.
//

import Foundation

struct Track: Decodable {
    
    enum TrackExtension: String, Decodable {
        case mp3
    }
    
    let resource: String
    let `extension`: TrackExtension
}


