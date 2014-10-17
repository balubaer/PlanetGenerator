//
//  Fleet.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

func fleetAndHomePlanetWithNumber(planets:Array<Planet>, number:Int) -> (fleet:Fleet?, homePlanet:Planet?) {
    var fleet:Fleet? = nil
    var homePlanet:Planet? = nil
    for planet in planets {
        for aFleet in planet.fleets {
            if aFleet.number == number {
                fleet = aFleet
                homePlanet = planet
                break
            }
        }
    }
    
    return (fleet, homePlanet)
}

class Fleet: Comparable, Equatable {
    var number: Int = 0
    var name: String {
        var desc = "F\(number)"
        if player != nil {
            desc += player!.description
        } else {
            desc += "[---]"
        }
        return desc
    }
    var ships: Int = 0
    var player: Player?
    var cargo: Int = 0
    var moved: Bool = false
    var ambusch: Bool = false
    
    //TODO: niklas Kunstwerke ... V70:Plastik Mondstein
    //TODO: niklas schenken

    var description: String {
        var desc = "\(name) = \(ships)"
        
        var infoString = createInfoString()
        
        if countElements(infoString) != 0 {
            desc += " "
            desc += infoString
        }
        
        return desc
    }
    
    init() {
    }
    
    func createInfoString() -> String {
        var infoArray:Array <String> = Array()
        var result:String = ""
        
        if moved {
            infoArray.append("bewegt")
        }
        if ambusch {
            infoArray.append("Ambush")
        }
        if cargo != 0 {
            infoArray.append("Fracht=\(cargo)")
        }
        
        if infoArray.count != 0 {
            
            result = createBracketAndCommarStringWithStringArray(infoArray)
        }

        return result
    }
    
}

func <=(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber <= rNumber
    return result
}

func >=(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber >= rNumber
    return result
}

func >(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber > rNumber
    
    return result
}

func <(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber < rNumber
    
    return result
}

func ==(lhs: Fleet, rhs: Fleet) -> Bool {
    var lNumber = lhs.number
    var rNumber = rhs.number
    var result = lNumber == rNumber
    
    return result
}
