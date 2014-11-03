//
//  FinalPhaseCoreGame.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 02.11.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class FinalPhaseCoreGame {
    var planets: Array <Planet>
    var allPlayerDict: [String: Player]

    init(aPlanetArray: Array <Planet>, aAllPlayerDict: [String: Player]) {
        planets = aPlanetArray
        allPlayerDict = aAllPlayerDict
    }
    
    func isSomeBodyOnPlanet(planet: Planet) -> Bool {
        var result = false
        
        for (playerName, player) in allPlayerDict {
            if Player.isPlayOnPlanet(player, planet: planet) {
                result = true
                break
            }
        }
        return result
    }
    
    func checkFireResults(planet: Planet) {
        //DShips
        planet.dShips -= planet.hitedShotsDShips/2
        if planet.dShips < 0 {
            planet.dShips = 0
        }
        planet.hitedShotsDShips = 0
        //Fleets
        for fleet in planet.fleets {
            if fleet.fleetMovements.count > 0 {
                fleet.ships -= fleet.hitedShots/4
            } else {
                fleet.ships -= fleet.hitedShots/2
            }
            fleet.hitedShots = 0
        }
    }
    
    func checkFleetMovement(planet: Planet) {
        var removeFleets: Array <Fleet> = Array()
        var counter = 0
        for fleet in planet.fleets {
            var fleetMovementCount = fleet.fleetMovements.count
            
            if fleetMovementCount > 0 {
                if fleet.ships > 0 {
                    removeFleets.append(fleet)
                    for fleetMovement in fleet.fleetMovements {
                        var fromPlanet = fleetMovement.fromPlanet
                        if planet != fromPlanet {
                            fromPlanet?.fleets.removeObject(fleet)
                        }
                        var toPlanet = fleetMovement.toPlanet
                        fromPlanet?.fleetMovements.append(fleetMovement)
                        toPlanet?.fleets.append(fleet)
                        
                        //TODO: Ambush
                    }
                }
                fleet.fleetMovements.removeAll()
            }
        }
        for fleet in removeFleets {
            planet.fleets.removeObject(fleet)
        }
    }
    
    func getPlayersFromFleets(fleets: Array <Fleet>) -> Array <Player> {
        var players: Array <Player> = Array()
        
        for fleet in fleets {
            if fleet.ships > 0 {
                var player = fleet.player
                
                if player != nil {
                    if contains(players, player!) == false {
                        players.append(player!)
                    }
                }
            }
        }
        return players
    }
    
    func checkOwnership(planet: Planet) {
        var players = self.getPlayersFromFleets(planet.fleets)

        //planet
        if planet.player == nil {
            if players.count == 1 {
                    planet.player = players[0]
            }
        } else {
            if planet.dShips == 0 {
                var player = planet.player!
                
                if players.count == 1 {
                    
                    if player != players[0] {
                        planet.player = players[0]
                    }
                }
            }
        }
        //fleets
        if players.count == 1 {
            for fleet in planet.fleets {
                fleet.player = players[0]
            }
        }
    }
    
    func doFinal() {
        for planet in planets {
            if self.isSomeBodyOnPlanet(planet) {
                self.checkFireResults(planet)
                self.checkFleetMovement(planet)
            }
        }
        for planet in planets {
            if self.isSomeBodyOnPlanet(planet) {
                self.checkOwnership(planet)
            }
        }
    }
}