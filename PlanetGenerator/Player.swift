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
    var ambushOff: Bool = false
    
    var description: String {
        var desc = "[\(name)]"
        if ambushOff {
            desc += "(Ambush aus)"
        }
        return desc
    }
    
    init() {
        name = "NO Name"
    }
    
    class func isPlayerInFleetsWithPlayer(player: Player, fleets: Array <Fleet>) -> Bool {
        var result = false
        for fleet in fleets {
            result = self.isFleetOwnedByPlayer(player, fleet: fleet)
        }
        return result
    }
    
    class func isFleetOwnedByPlayer(player: Player, fleet: Fleet) -> Bool {
        var result = false
        if fleet.player != nil {
            if fleet.player! == player {
                result = true
            }
        }
        return result
    }

    class func isPlayerInFleetMovementWithPlayer(player: Player, fleetMovements: Array <FleetMovement>) -> Bool {
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
    
    class func isPlanetOwnedByPlayer(player: Player, planet: Planet) -> Bool {
        var result = false

        if planet.player != nil {
            if planet.player! == player {
                result = true
            }
        }
        return result
    }
    
    class func isPlayOnPlanetWithPlayer(player: Player, planet: Planet) -> Bool {
        //Test Planet
        var result = self.isPlanetOwnedByPlayer(player, planet: planet)
        
        //Test Fleets
        if result == false {
            result = self.isPlayerInFleetsWithPlayer(player, fleets: planet.fleets)
        }

        return result
    }
    
    class func isPlayerInPlanetHitAmbuschPlayersWithPlayer(aPlayer: Player, hitAmbuschPlayers: Array <Player>) -> Bool {
        var result = false
        
        for player in hitAmbuschPlayers {
            if player == aPlayer {
                result = true
                break
            }
        }
        return result;
    }
    
    class func isPlanetOutPutForPlayer(player: Player, planet: Planet) -> Bool {
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
            result = self.isPlayerInPlanetHitAmbuschPlayersWithPlayer(player, hitAmbuschPlayers: planet.hitAmbuschPlayers)
        }
        return result
    }
    
    func getXMLElement() -> NSXMLElement {
        let childElementPlayer = NSXMLElement(name: "player")
        //TODO: niklas woher kommt diese?
        if let attribute = NSXMLNode.attributeWithName("accountId", stringValue: "01601386") as? NSXMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = NSXMLNode.attributeWithName("handle", stringValue: name) as? NSXMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = NSXMLNode.attributeWithName("fullName", stringValue: name) as? NSXMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = NSXMLNode.attributeWithName("stillInGame", stringValue: "True") as? NSXMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        if let attribute = NSXMLNode.attributeWithName("prevScore", stringValue: "\(points)") as? NSXMLNode {
            childElementPlayer.addAttribute(attribute)
        }
        //TODO niklas das ist so noch nicht richtig
        if let attribute = NSXMLNode.attributeWithName("score", stringValue: "\(points)") as? NSXMLNode {
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
