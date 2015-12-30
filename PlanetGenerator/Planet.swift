//
//  Planet.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation


func planetWithNumber(planets:Array<Planet>, number:Int) -> Planet? {
    var result:Planet? = nil
    for planet in planets {
        if planet.number == number {
            result = planet
            break
        }
    }
    
    return result;
}

class Planet: Comparable, Equatable {
    var number: Int = 0
    var name: String {
        let aName = "W\(number)"
        return aName
    }
    var port: Port?
    var player: Player?
    var fleets: Array <Fleet>
    var fleetMovements: Array <FleetMovement> = Array()
    var ambushOff: Bool = false
    var industry: Int = 0
    var usedIndustry: Int = 0
    var effectiveIndustry: Int {
        var result: Int = 0
        if industry <= metal {
            result = industry
        } else {
            result = metal
        }
        return result
    }
    var metal: Int = 0
    var mines: Int = 0
    var population: Int = 0
    var limit: Int = 0
    var round: Int = 0
    var iShips: Int = 0
    var pShips: Int = 0
    var dShips: Int = 0
    var dShipsFired: Bool = false
    var dShipsAmbush: Bool = false
    
    var hitAmbuschPlayers: Array <Player> = Array()
    
    var hitedShotsDShips: Int = 0
    
    //TODO: niklas Kunstwerke ... V70:Plastik Mondstein
    
    var description: String {
        var desc = self.name
        if port != nil {
            desc = port!.description
        }
        if player != nil {
            desc += " \(player!.description)"
        }
        
        let resouceString = createResourceString()
        
        if resouceString.characters.count != 0 {
            desc += " "
            desc += resouceString
        }
        
        if fleets.count > 0 {
            for fleet in fleets {
                desc += "\n   "
                desc += fleet.description
            }
        }
        
        let fleetMovementsCount = fleetMovements.count
        
        if fleetMovementsCount > 0 {
            var counter = 0
            
            desc += "\n   ("
            for fleetMovement in fleetMovements {
                desc += fleetMovement.description
                counter++
                if counter < fleetMovementsCount {
                    desc += " "
                }
            }
            desc += ")"
        }
        
        return desc
    }
    
    init() {
        fleets = Array()
    }
    
    func addHitAmbushPlayer(aPlayer: Player) {
        if hitAmbuschPlayers.contains(aPlayer) != true {
            hitAmbuschPlayers.append(aPlayer)
        }
    }
    
    func hasConnectionToPlanet(aPlant : Planet) -> Bool {
        var result = false
        if port != nil {
            result = port!.hasConnectionToPlanet(aPlant)
        }
        return result
    }
    
    func createResourceString () -> String {
        var resourceArray:Array <String> = Array()
        var result:String = ""
        
        if ambushOff {
            resourceArray.append("Ambush 'Aus' für diese Runde!!!")
        }
        if industry != 0 {
            resourceArray.append("Industrie=\(industry)")
        }
        if metal != 0 {
            resourceArray.append("Metall=\(metal)")
        }
        if mines != 0 {
            resourceArray.append("Minen=\(mines)")
        }
        if population != 0 {
            resourceArray.append("Bevoelkerung=\(population)")
        }
        if limit != 0 {
            resourceArray.append("Limit=\(limit)")
        }
        if round != 0 {
            resourceArray.append("Runden=\(round)")
        }
        if iShips != 0 {
            resourceArray.append("I-Schiffe=\(iShips)")
        }
        if pShips != 0 {
            resourceArray.append("P-Schiffe=\(pShips)")
        }
        if dShips != 0 {
            if dShipsAmbush {
                resourceArray.append("D-Schiffe=\(dShips) (Ambusch)")
                
            } else {
                resourceArray.append("D-Schiffe=\(dShips)")
            }
        }
        if resourceArray.count != 0 {
            
            result = createBracketAndCommarStringWithStringArray(resourceArray)
        }
        return result
    }
    
    func getXMLElementForPlayer(aPlayer: Player) -> NSXMLElement {
        let childElementPlanet = NSXMLElement(name: "world")
        if let attribute = NSXMLNode.attributeWithName("completeInfo", stringValue: "True") as? NSXMLNode {
            childElementPlanet.addAttribute(attribute)
        }
        
        if let attribute = NSXMLNode.attributeWithName("hasSeen", stringValue: "\(aPlayer.name):0") as? NSXMLNode {
            childElementPlanet.addAttribute(attribute)
        }
        
        if let aLetPlayer = player {
            if let attribute = NSXMLNode.attributeWithName("owner", stringValue: "\(aLetPlayer.name)") as? NSXMLNode {
                childElementPlanet.addAttribute(attribute)
            }
        }
        if let attribute = NSXMLNode.attributeWithName("index", stringValue: "\(self.number)") as? NSXMLNode {
            childElementPlanet.addAttribute(attribute)
        }
        
        if let attribute = NSXMLNode.attributeWithName("unloadCounter", stringValue: "") as? NSXMLNode {
            childElementPlanet.addAttribute(attribute)
        }
        self.addXMLConnectOnParent(childElementPlanet)
        self.addXMLPassingOnParent(childElementPlanet)
        self.addXMLFleetOnParent(childElementPlanet)
        let childElementHomeFleet = NSXMLElement(name: "homeFleet")
        if let attribute = NSXMLNode.attributeWithName("key", stringValue: "D") as? NSXMLNode {
            childElementHomeFleet.addAttribute(attribute)
        }
        if let attribute = NSXMLNode.attributeWithName("ships", stringValue: "\(dShips)") as? NSXMLNode {
            childElementHomeFleet.addAttribute(attribute)
        }
        childElementPlanet.addChild(childElementHomeFleet)
        return childElementPlanet
    }
    
    func addXMLConnectOnParent(parent : NSXMLElement) {
        if let aPort = port {
            aPort.addXMLConnectOnParent(parent)
        }
    }
    
    func addXMLPassingOnParent(parent: NSXMLElement) {
        if fleetMovements.count > 0 {
            for fleetMovement in fleetMovements {
                fleetMovement.addXMLPassingOnParent(parent)
            }
        }
    }
    
    func addXMLFleetOnParent(parent : NSXMLElement) {
        for fleet in fleets {
            fleet.addXMLFleetOnParent(parent)
        }
    }
}

func <=(lhs: Planet, rhs: Planet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber <= rNumber
    return result
}

func >=(lhs: Planet, rhs: Planet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber >= rNumber
    return result
}

func >(lhs: Planet, rhs: Planet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber > rNumber

    return result
}

func <(lhs: Planet, rhs: Planet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber < rNumber

    return result
}

func ==(lhs: Planet, rhs: Planet) -> Bool {
    let lNumber = lhs.number
    let rNumber = rhs.number
    let result = lNumber == rNumber
   
    return result
}
