//
//  Player.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Player: Equatable, Hashable {
    var name: String
    var points: Int = 0
    var role: Role?
    var ambushOff: Bool = false
    var teammates: Set <Player> = Set()
    
    var teanmatesNames: Array <String> {
        var result = Array<String>()
        for teammatePlayer in teammates {
            result.append(teammatePlayer.name)
        }
        return result
    }
    
    var description: String {
        var desc = "[\(name)]"
        if ambushOff {
            desc += "(Ambush aus)"
        }
        return desc
    }
    
    internal var hashValue: Int {
        return name.hashValue
    }

    init() {
        name = "NO Name"
    }
    
    class func isPlayerInFleetsWithPlayer(_ player: Player, fleets: Array <Fleet>) -> Bool {
        var result = false
        for fleet in fleets {
            result = self.isFleetOwnedByPlayer(player, fleet: fleet)
            if result {
                break;
            }
        }
        return result
    }
    
    class func isFleetOwnedByPlayer(_ player: Player, fleet: Fleet) -> Bool {
        var result = false
        if fleet.player != nil {
            if fleet.player! == player {
                result = true
            }
        }
        return result
    }

    class func isPlayerInFleetMovementWithPlayer(_ player: Player, fleetMovements: Array <FleetMovement>) -> Bool {
        var result = false
        for fleetMovement in fleetMovements {
            if fleetMovement.fleet != nil {
                if fleetMovement.fleet!.player != nil {
                    let movementPlayer = fleetMovement.fleet!.player!
                    if movementPlayer == player {
                        result = true
                        break
                    }
                }
            }
        }
        return result
    }
    
    class func isPlanetOwnedByPlayer(_ player: Player, planet: Planet) -> Bool {
        var result = false

        if planet.player != nil {
            if planet.player! == player {
                result = true
            }
        }
        return result
    }
    
    class func isPlayOnPlanetWithPlayer(_ player: Player, planet: Planet) -> Bool {
        //Test Planet
        var result = self.isPlanetOwnedByPlayer(player, planet: planet)
        
        //Test Fleets
        if result == false {
            result = self.isPlayerInFleetsWithPlayer(player, fleets: planet.fleets)
        }

        return result
    }
    
    class func isPlayerInPlanetHitAmbushFleetWithPlayer(_ aPlayer: Player, hitAmbuschFleets: Array <Fleet>) -> Bool {
        var result = false
        
        for fleet in hitAmbuschFleets {
            if let player = fleet.player {
                if player == aPlayer {
                    result = true
                    break
                }
            }
        }
        return result;
    }
    
    class func isPlanetOutPutForPlayer(_ player: Player, planet: Planet) -> Bool {
        //Test Planet
        var result = self.isPlanetOwnedByPlayer(player, planet: planet)
        
        //Test Fleets
        if result == false {
            result = self.isPlayerInFleetsWithPlayer(player, fleets: planet.fleets)
        }
        
        //Test FleetMovement
        if result == false {
            result = self.isPlayerInFleetMovementWithPlayer(player, fleetMovements: planet.fleetMovements)
        }
        
        //Test planet.hitAmbuschPlayers
        if result == false {
            result = self.isPlayerInPlanetHitAmbushFleetWithPlayer(player, hitAmbuschFleets: planet.hitAmbuschFleets)
        }
        return result
    }
    
    func getXMLElement() -> XMLElement {
        let childElementPlayer = XMLElement(name: "player")
        //TODO: niklas woher kommt diese?
        if let attribute = XMLNode.attribute(withName: "accountId", stringValue: "01601386") as? XMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = XMLNode.attribute(withName: "handle", stringValue: name) as? XMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = XMLNode.attribute(withName: "fullName", stringValue: name) as? XMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = XMLNode.attribute(withName: "stillInGame", stringValue: "True") as? XMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = XMLNode.attribute(withName: "prevScore", stringValue: "\(points)") as? XMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        //TODO niklas das ist so noch nicht richtig
        if let attribute = XMLNode.attribute(withName: "score", stringValue: "\(points)") as? XMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        return childElementPlayer;
    }
    
 }

func ==(lhs: Player, rhs: Player) -> Bool {
    let lName = lhs.name
    let rName = rhs.name
    let result = (lName == rName)
    
    return result
}
