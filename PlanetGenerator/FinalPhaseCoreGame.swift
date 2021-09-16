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
        
        for (_, player) in allPlayerDict {
            if Player.isPlayOnPlanetWithPlayer(player, planet: planet) {
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
            if fleet.ships < 0 {
                fleet.ships = 0
            }
        }
    }
    
    func isAmbushFromMovementCount(movementCount: Int, movementHoleCount: Int) -> Bool {
        var result = false
        
        switch movementHoleCount {
        case 2:
            switch movementCount {
            case 1:
                result = true
            default:
                result = false
            }
        case 3:
            switch movementCount {
            case 1, 2:
                result = true
            default:
                result = false
            }
        default:
            result = false
        }
        
        return result
    }
    
    func isAmbushPlanet(planet: Planet?, passingFleet: Fleet, movementCount: Int) -> Bool {
        var result = false
        if planet!.ambushOff == false {
            if isAmbushFromMovementCount(movementCount: movementCount, movementHoleCount: passingFleet.fleetMovements.count) {
                if planet != nil {
                    let planetPlayer = planet!.player
                    let fleetPlayer = passingFleet.player
                    
                    if planetPlayer != nil {
                        if fleetPlayer != nil {
                            if (planetPlayer! == fleetPlayer!) == false {
                                if planetPlayer!.teammates.contains(fleetPlayer!) == false {
                                    result = true
                                }
                            }
                        }
                   }
                }
            }
        }
        
        return result
    }
    
    func isAmbushFleet(ambushFleet: Fleet, passingFleet: Fleet, movementCount: Int) -> Bool {
        var result = false
        if isAmbushFromMovementCount(movementCount: movementCount, movementHoleCount: passingFleet.fleetMovements.count) {
            if (ambushFleet == passingFleet) == false {
                if ambushFleet.fired == false {
                    if ambushFleet.moved == false {
                        if let ambushPlayer = ambushFleet.player {
                            if let passingFleetPlayer = passingFleet.player {
                                if (ambushPlayer == passingFleetPlayer) == false {
                                    if ambushPlayer.teammates.contains(passingFleetPlayer) == false {
                                        result = true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return result;
    }
    
    func getFirePowerForAmbushPlanet(planet: Planet?) -> Int {
        var firePower = 0
        
        if planet != nil {
            if planet!.dShipsFired == false {
                firePower += planet!.dShips
                planet!.dShipsAmbush = true
            }
        }
        return firePower
    }
    
    //TODO: niklas func getFirePowerFor
    func checkFleetMovement(planet: Planet) {
        for fleet in planet.fleets {
            let fleetMovementCount = fleet.fleetMovements.count
            
            if fleetMovementCount > 0 {
                if fleet.ships > 0 {
                    var movementCount = 1
                    for fleetMovement in fleet.fleetMovements {
                        if fleetMovement.isMovementDone == false {
                            if let fromPlanet = fleetMovement.fromPlanet {
                                if let toPlanet = fleetMovement.toPlanet {
                                    fromPlanet.fleets.removeObject(fleet)
                                    fromPlanet.fleetMovements.append(fleetMovement)
                                    toPlanet.fleets.append(fleet)
                                    fleetMovement.isMovementDone = true
                                    
                                    if isAmbushPlanet(planet: toPlanet, passingFleet: fleet, movementCount: movementCount) {
                                        let firePower = getFirePowerForAmbushPlanet(planet: toPlanet)
                                        fleet.ships -= firePower
                                        if fleet.ships < 0 {
                                            fleet.ships = 0
                                        }
                                        toPlanet.addHitAmbushFleets(fleet)
                                    }
                                    for fleetFromPlanet in toPlanet.fleets {
                                        if isAmbushFleet(ambushFleet: fleetFromPlanet, passingFleet: fleet, movementCount: movementCount) {
                                            fleet.ships -= fleetFromPlanet.ships;
                                            if fleet.ships < 0 {
                                                fleet.ships = 0
                                            }
                                            fleetFromPlanet.addHitAmbushFleets(fleet)
                                            fleetFromPlanet.ambush = true
                                        }
                                    }
                                    
                                    if fleet.ships == 0 {
                                        break;
                                    }
                                }
                            }
                            movementCount += 1
                        }
                    }
                }
            }
        }
    }
    
    func getPlayersFromFleets(fleets: Array <Fleet>) -> Array <Player> {
        var players: Array <Player> = Array()
        
        for fleet in fleets {
            if fleet.ships > 0 {
                let player = fleet.player
                
                if player != nil {
                    if players.contains(player!) == false {
                        players.append(player!)
                    }
                }
            }
        }
        return players
    }
    
    func checkOwnership(planet: Planet) {
        var players = getPlayersFromFleets(fleets: planet.fleets)

        //planet
        if planet.player == nil {
            if players.count == 1 {
                    planet.player = players[0]
            }
        } else {
            if planet.dShips == 0 {
                let player = planet.player!
                
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
        } else {
            for fleet in planet.fleets {
                if fleet.ships == 0 {
                    fleet.player = nil
                }
            }
        }
    }
    
    func calculatePoints(planet: Planet) {
        if planet.player != nil {
            planet.player!.points += 20
        }
    }
    
    func doFinal() {
        for planet in planets {
            if self.isSomeBodyOnPlanet(planet: planet) {
                self.checkFireResults(planet: planet)
                checkFleetMovement(planet: planet)
            }
        }
        for planet in planets {
            if self.isSomeBodyOnPlanet(planet: planet) {
                checkOwnership(planet: planet)
                calculatePoints(planet: planet)
            }
        }
    }
}
