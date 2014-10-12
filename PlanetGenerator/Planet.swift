//
//  Planet.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Planet: Comparable, Equatable {
    var number: Int = 0
    var name: String {
        var aName = "W\(number)"
        return aName
    }
    var ports: Port?
    var player: Player?
    var fleets: Array <Fleet>
    var industry: Int = 0
    var metal: Int = 0
    var mines: Int = 0
    var population: Int = 0
    var limit: Int = 0
    var round: Int = 0
    
    //TODO: niklas Kunstwerke ... V70:Plastik Mondstein
    
    var description: String {
        var desc = self.name
        if ports != nil {
            desc = ports!.description
        }
        if player != nil {
            desc += " \(player!.description)"
        }
        
        return desc
    }
    
    init() {
        fleets = Array()
    }
    
    func hasConnectionToPlanet(aPlant : Planet) -> Bool {
        var result = false
        if ports != nil {
            result = ports!.hasConnectionToPlanet(aPlant)
        }
        return result
    }
}

func <=(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber <= rNumber
    return result
}

func >=(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber >= rNumber
    return result
}

func >(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber > rNumber

    return result
}

func <(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber < rNumber

    return result
}

func ==(lhs: Planet, rhs: Planet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber == rNumber
   
    return result
}
