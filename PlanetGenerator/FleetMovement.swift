//
//  FleetMovement.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class FleetMovement {
    var fleet: Fleet?
    var toPlanet: Planet?
    var fromPlanet: Planet?
    var isMovementDone: Bool = false
    
    var description: String {
        var desc = "(---)"
        if fleet != nil && toPlanet != nil {
            desc = "\(fleet!.name)-->\(toPlanet!.name)"
        }
        return desc
    }
    
    init() {
    }
    
}