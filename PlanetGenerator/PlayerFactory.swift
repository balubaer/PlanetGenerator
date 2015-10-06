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
    var playerDice: Dice
    var distanceLevelHomes: Int
    var playerNameArray: Array <String>
    var passedPlanets: Array <Planet> = Array()
    var nextLevelPlanets: Array <Planet> = Array()
    var homePlanetsDict: [String: Planet] = Dictionary()

    init(aPlayerNameArray: Array <String>) {
        planetDice = Dice()
        fleetDice = Dice()
        playerDice = Dice()
        playerNameArray = aPlayerNameArray
        distanceLevelHomes = 0
    }
    
    func findPlanetWithDice(dice:Dice, planetArray:Array <Planet>) -> Planet {
        var result:Planet? = nil
        var found = false
        
        while (!found) {
            result = planetWithNumber(planetArray, number: dice.roll())
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
        let aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planetArray, number: dice.roll())
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
    
    func findePlayerWithDice() -> Player {
        let result = Player()
        playerDice.setSites(playerNameArray.count)
        let index = playerDice.roll() - 1
        let playerName =  playerNameArray.removeAtIndex(index)
        result.name = playerName
        return result
    }

    
    func createWithPlanetArray(planetArray:Array <Planet>, fleetCount: Int, aFleetsOnHomePlanet: Int, startShipsCount: Int, distanceLevelHomes: Int) {
        var counter = 1
        planetDice.setSites(planetArray.count)
        fleetDice.setSites(fleetCount)
        let playerNameCount: Int = playerNameArray.count;
        self.distanceLevelHomes = distanceLevelHomes

        for _ in 1...playerNameCount {
            var fleetsOnHomePlanet = aFleetsOnHomePlanet
            let player = findePlayerWithDice();
            var planet : Planet;
            if (counter == 1) {
                planet = findPlanetWithDice(planetDice, planetArray: planetArray)
            } else {
                nextLevelPlanets = makeNextLevelPlanets();
                planet = findPlanetWithDice(planetDice, planetArray: nextLevelPlanets);
            }
            planet.player = player;
            homePlanetsDict[player.name] = planet;
            
            fleetsOnHomePlanet -= planet.fleets.count
            for fleet in planet.fleets {
                fleet.player = player;
                fleet.ships = startShipsCount;
            }
            
            for _ in 1...fleetsOnHomePlanet {
                let fleetAndPlanet = findFleetAndPlanetWithDice(fleetDice, planetArray: planetArray)
                fleetAndPlanet.fleet.player = player
                fleetAndPlanet.fleet.ships = startShipsCount
                fleetAndPlanet.planet.fleets.removeObject(fleetAndPlanet.fleet)
                planet.fleets.append(fleetAndPlanet.fleet)
            }

            counter++;

        }
    }
    
    func makeNextLevelPlanets() -> Array <Planet> {
        var result = Array<Planet>()
        var allPassedPlanets = Array<Planet>()
        var allNextLevelPlanets = Array<Planet>()
        var finishCreate = false
        var startDistanceLevelHomes = distanceLevelHomes
        
        while finishCreate == false {
            for planet in  homePlanetsDict.values {
                let distLevel = DistanceLevel(aStartPlanet: planet, aDistanceLevel: startDistanceLevelHomes);
                for planetFromPassedPlanets in distLevel.passedPlanets {
                    if allPassedPlanets.contains(planetFromPassedPlanets) == false {
                        allPassedPlanets.append(planetFromPassedPlanets)
                    }
                }
                for planetFromNextLevel in distLevel.nextLevelPlanets {
                    if allNextLevelPlanets.contains(planetFromNextLevel) == false {
                        allNextLevelPlanets.append(planetFromNextLevel)
                    }
                }
                for planetFromNextLevel in allNextLevelPlanets {
                    if allPassedPlanets.contains( planetFromNextLevel) == false {
                        result.append(planetFromNextLevel)
                    }
                }
            }
            if result.count > 0 {
                finishCreate = true
            } else {
                startDistanceLevelHomes--;
                allPassedPlanets.removeAll()
                allNextLevelPlanets.removeAll()
            }
        }
        distanceLevelHomes = startDistanceLevelHomes;
        return result;
    }

    
}
