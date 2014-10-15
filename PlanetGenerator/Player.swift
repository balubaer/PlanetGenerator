//
//  Player.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Player: Equatable {
    var name: String
    var points: Int = 0
    var role: Role?
    
    var description: String {
        var desc = "[\(name)]"
        return desc
    }
    
    init() {
        name = "NO Name"
    }
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    var lName = lhs.name
    var rName = rhs.name
    var result = (lName == rName)
    
    return result
}
