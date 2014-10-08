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
    var connectionsCount:Int
    var planet:Planet?
    
    init() {
        planets = Array()
        connectionsCount = 0
      //  planet = nil
    }
    
    var description: String {
        var desc = " Port: connectionsCount [\(connectionsCount)] ";
        
        if planet != nil {
            desc = desc + "MainPlanet <\(planet!.number)>\n"
        }
        planets.sort { $0 < $1 }
        for item in planets {
            var number = item.number
            desc = desc + " ToPlanet <\(number)>"
        }

        return desc
    }
}
