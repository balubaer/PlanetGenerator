//
//  Port.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Port {
    var planets:Array <Planet>
    var planet:Planet?
    
    init() {
        planets = Array()
    }
    
    var description: String {
        var desc = ""
        var connectionCount = planets.count
        if planet != nil {
            desc = planet!.name
        }  else {
            desc = "W?"
        }
        if (connectionCount > 0) {
            var counter = 0
            desc += "("
            planets.sort { $0 < $1 }
            for item in planets {
                var number = item.number
                desc += "\(number)"
                if counter < (connectionCount - 1) {
                    desc += ","
                }
                counter++;
            }
            desc += ")"
        }
        return desc
    }
    
    func hasConnectionToPlanet(aPlant : Planet) -> Bool {
        return contains(planets, aPlant)
    }

}
