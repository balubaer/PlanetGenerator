//
//  PlayerFactory.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 23.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class PlayerFactory {
    var planetDice: Dice
    var fleetDice: Dice
    var playerNameArray: Array <String>
    
    init(aPlayerNameArray: Array <String>) {
        planetDice = Dice()
        fleetDice = Dice()
        playerNameArray = aPlayerNameArray
    }
    
    func findPlanetWithDice(dice:Dice, planetArray:Array <Planet>) -> Planet {
        var result:Planet? = nil
        var found = false
        
        while (!found) {
            result = planetWithNumber(planetArray, dice.roll())
            if result != nil {
                if result!.player == nil {
                    found = true
                }
            }
        }
        return result!
    }
    
    func findFleetAndPlanetWithDice(dice:Dice, planetArray:Array <Planet>) -> (fleet:Fleet, planet:Planet) {
        var fleet:Fleet? = nil
        var planet:Planet? = nil
        var found = false

        while (!found) {
        var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray, dice.roll())
            if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                if aFleetAndHomePlanet.fleet!.player == nil {
                    found = true
                    fleet = aFleetAndHomePlanet.fleet!
                    planet = aFleetAndHomePlanet.homePlanet
                }
            }
        }
        return (fleet!, planet!)
    }
    
    func createWithPlanetArray(planetArray:Array <Planet>, fleetCount: Int, aFleetsOnHomePlanet: Int, startShipsCount: Int) {
        planetDice.setSites(planetArray.count)
        fleetDice.setSites(fleetCount)
        
        for name in playerNameArray {
            var fleetsOnHomePlanet = aFleetsOnHomePlanet
            var player = Player()
            player.name = name

            var planet: Planet = findPlanetWithDice(planetDice, planetArray: planetArray)
            planet.player = player
            
            fleetsOnHomePlanet -= planet.fleets.count
            
            for fleet in planet.fleets {
                fleet.player = player
                fleet.ships = startShipsCount
            }
            
            for index in 1...fleetsOnHomePlanet {
                var fleetAndPlanet = findFleetAndPlanetWithDice(fleetDice, planetArray: planetArray)
                fleetAndPlanet.fleet.player = player
                fleetAndPlanet.fleet.ships = startShipsCount
                fleetAndPlanet.planet.fleets.removeObject(fleetAndPlanet.fleet)
                planet.fleets.append(fleetAndPlanet.fleet)
            }
        }
    }
}
