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
    
    class func isPlayOnPlanet(player: Player, planet: Planet) -> Bool {
        var result = false
        
        if planet.player != nil {
            if planet.player! == player {
                result = true
            }
            
            if result == false {
                for fleet in planet.fleets {
                    if fleet.player != nil {
                        if fleet.player! == player {
                            result = true
                            break
                        }
                    }
                }
            }
        } else {
            for fleet in planet.fleets {
                if fleet.player != nil {
                    if fleet.player! == player {
                        result = true
                        break
                    }
                }
            }
        }
        return result
    }
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    var lName = lhs.name
    var rName = rhs.name
    var result = (lName == rName)
    
    return result
}
