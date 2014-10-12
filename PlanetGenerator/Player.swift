//
//  Player.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Player {
    var name: String
    var points: Int = 0
    var character: Character?
    
    var description: String {
        var desc = "[\(name)]"
        return desc
    }
    
    init() {
        name = "NO Name"
    }
    
}
