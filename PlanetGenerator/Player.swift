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
            if fleet.player != nil {
                if fleet.player! == player {
                    result = true
                    break
                }
            }
        }
        return result
    }
    
    class func isPlayerInFleetMovementWithPlayer(player: Player, fleetMovements: Array <FleetMovement>) -> Bool {
        var result = false
        for fleetMovement in fleetMovements {
            if fleetMovement.fleet != nil {
                if fleetMovement.fleet!.player != nil {
                    var movementPlayer = fleetMovement.fleet!.player!
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
    
}

func ==(lhs: Player, rhs: Player) -> Bool {
    var lName = lhs.name
    var rName = rhs.name
    var result = (lName == rName)
    
    return result
}
