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
    var moved: Bool {
        return fleetMovements.count > 0
    }
    var ambush: Bool = false
    var hitedShots: Int = 0
    
    var fleetMovements: Array <FleetMovement> = Array()
    var fired: Bool = false
    var firesTo: String = ""
    var firesToCommand: String = ""

    var hitAmbuschFleets: Array <Fleet> = Array()
    
    var fireAmbuschFleets: String {
        var desc = "Ambush:"
        for hitAmbushfleet in hitAmbuschFleets {
            desc += "F\(hitAmbushfleet.number),"
        }
        return String(desc.characters.dropLast())
    }

    //TODO: niklas Kunstwerke ... V70:Plastik Mondstein
    //TODO: niklas schenken

    var description: String {
        var desc = "\(name) = \(ships)"
        
        let infoString = createInfoString()
        
        if infoString.characters.count != 0 {
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
        if ambush {
            var desc = "Ambush: {"
            if hitAmbuschFleets.count > 0 {
                var counter = 0
                
                for fleet in hitAmbuschFleets {
                    desc += fleet.name
                    counter++
                    if counter < hitAmbuschFleets.count {
                        desc += ", "
                    }
                }
                desc += "}"
            }
            infoArray.append(desc)
        }
        if fired {
            infoArray.append("feuert auf \(firesTo)")
        }
        if cargo != 0 {
            infoArray.append("Fracht=\(cargo)")
        }
        
        if infoArray.count != 0 {
            
            result = createBracketAndCommarStringWithStringArray(infoArray)
        }

        return result
    }
    
    func addHitAmbushFleets(aFleet: Fleet) {
        if hitAmbuschFleets.contains(aFleet) != true {
            let fleetClone = Fleet();
            fleetClone.player = aFleet.player
            fleetClone.ships = aFleet.ships
            fleetClone.number = aFleet.number
            hitAmbuschFleets.append(fleetClone)
        }
    }

    func addXMLFleetOnParent(parent : NSXMLElement) {
        let childElementFleet = NSXMLElement(name: "fleet")
        if let attribute = NSXMLNode.attributeWithName("completeInfo", stringValue: "True") as? NSXMLNode {
            childElementFleet.addAttribute(attribute)
        }
        
        if firesToCommand != "" {
            if let attribute = NSXMLNode.attributeWithName("fired", stringValue: "\(firesToCommand)") as? NSXMLNode {
                childElementFleet.addAttribute(attribute)
            }
        }
        if ambush {
            if let attribute = NSXMLNode.attributeWithName("fired", stringValue: "\(fireAmbuschFleets)") as? NSXMLNode {
                childElementFleet.addAttribute(attribute)
            }
        }
        if let attribute = NSXMLNode.attributeWithName("index", stringValue: "\(number)") as? NSXMLNode {
            childElementFleet.addAttribute(attribute)
        }
        var movedString = "False"
        if moved {
            movedString = "True"
        }
        if let attribute = NSXMLNode.attributeWithName("moved", stringValue: movedString) as? NSXMLNode {
            childElementFleet.addAttribute(attribute)
        }
        if let aPlayer = player {
            if let attribute = NSXMLNode.attributeWithName("owner", stringValue: aPlayer.name) as? NSXMLNode {
                childElementFleet.addAttribute(attribute)
            }
            if let attribute = NSXMLNode.attributeWithName("prevOwner", stringValue: aPlayer.name) as? NSXMLNode {
                childElementFleet.addAttribute(attribute)
            }
        }
        if let attribute = NSXMLNode.attributeWithName("ships", stringValue: "\(ships)") as? NSXMLNode {
            childElementFleet.addAttribute(attribute)
        }
        parent.addChild(childElementFleet)
    }
    
}

func <=(lhs: Fleet, rhs: Fleet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber <= rNumber
    return result
}

func >=(lhs: Fleet, rhs: Fleet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber >= rNumber
    return result
}

func >(lhs: Fleet, rhs: Fleet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber > rNumber
    
    return result
}

func <(lhs: Fleet, rhs: Fleet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber < rNumber
    
    return result
}

func ==(lhs: Fleet, rhs: Fleet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber == rNumber
    
    return result
}
