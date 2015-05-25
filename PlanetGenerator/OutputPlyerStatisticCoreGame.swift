//
//  OutputPlyerStatistic.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 25.05.15.
//  Copyright (c) 2015 Bernd Niklas. All rights reserved.
//

import Foundation

//TODO: OutputPlyerStatistic (Punkte Anzahl Planeten Flotten Schiffe D-Schiffe
class OutputPlyerStatisticCoreGame {
    var player: Player
    var planets: Array <Planet>
    var planetsCount: Int
    var fleetCount: Int
    var shipsOnFleetsCount: Int
    var dShipCount: Int
    
    var description: String {
        var desc = "Punkte: \(player.points) | "
        desc += "Flotten: \(fleetCount) | "
        desc += "Schiffe auf Flotten: \(shipsOnFleetsCount) | "
        desc += "D-Schiffe: \(dShipCount)\n"
        return desc
    }
    
    init(aPlanets: Array <Planet>, aPlayer: Player) {
        player = aPlayer
        planets = aPlanets
        planetsCount = 0
        fleetCount = 0
        shipsOnFleetsCount = 0
        dShipCount = 0
    }
    
    func calculateStatistic() {
        for planet in planets {
            //Test Planet
            if Player.isPlanetOwnedByPlayer(player, planet: planet) {
                planetsCount++
                dShipCount = dShipCount + planet.dShips
            }
            
            for fleet in planet.fleets {
                //Test Fleets
                if Player.isFleetOwnedByPlayer(player, fleet: fleet) {
                    fleetCount++
                    shipsOnFleetsCount = shipsOnFleetsCount + fleet.ships
                }
            }
        }
    }
}