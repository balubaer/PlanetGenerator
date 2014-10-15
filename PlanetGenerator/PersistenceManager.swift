//
//  PersistenceManager.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 15.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    var planetArray: Array <Planet>
    
    init(aPlanetArray: Array <Planet>) {
        planetArray = aPlanetArray
    }
    
    func writePlanetPListWithPlanetArray(aPath: String) {
        var dictForPList = [String:AnyObject]()
        var planetArrayForPList = [[String:AnyObject]]()
        var portArrayForPList = [[String:AnyObject]]()
        var fleetArrayForPList = [[String:AnyObject]]()
        var playerDictForPList = [String:AnyObject]()

        var TestList = [Int]()
        
        for planet in planetArray {
            var planetDict = [String: AnyObject]()
            
            planetDict["number"] = planet.number
            planetDict["name"] = planet.name
            if planet.player != nil && planet.player!.role != nil {
                planetDict["player"] = planet.player!.name
                playerDictForPList[planet.player!.name] = ["points":planet.player!.points, "role": planet.player!.role!.name]
            }
            
            var fleetArray: Array <Int> = Array()
            for fleet in planet.fleets {
                var fleetDict = [String: AnyObject]()
                fleetArray.append(fleet.number)
                
                fleetDict["number"] = fleet.number
                fleetDict["ships"] = fleet.ships
                if fleet.player != nil {
                    fleetDict["player"] = fleet.player!.name
                }
                fleetDict["cargo"] = fleet.cargo
                fleetDict["moved"] = fleet.moved
                fleetDict["ambusch"] = fleet.ambusch
                fleetArrayForPList.append(fleetDict)
            }
            planetDict["fleets"] = fleetArray
            
            if planet.port != nil && planet.port!.planet != nil {
                var portDict = [String: AnyObject]()
                portDict["planet"] = planet.port!.planet!.number
                var aPlanetsArray: Array <Int> = Array()

                for planet in planet.port!.planets {
                    aPlanetsArray.append(planet.number)
                }
                portDict["planets"] = aPlanetsArray
                planetDict["port"] = planet.port!.planet!.number
                portArrayForPList.append(portDict)
            }
            planetDict["industry"] = planet.industry
            planetDict["metal"] = planet.metal
            planetDict["mines"] = planet.mines
            planetDict["population"] = planet.population
            planetDict["limit"] = planet.limit
            planetDict["round"] = planet.round
            planetDict["iShips"] = planet.iShips
            planetDict["pShips"] = planet.pShips
            planetArrayForPList.append(planetDict)
        }
        dictForPList["planets"] = planetArrayForPList
        dictForPList["player"] = playerDictForPList
        dictForPList["ports"] = portArrayForPList
        dictForPList["fleets"] = fleetArrayForPList
        
        (dictForPList as  NSDictionary).writeToFile(aPath, atomically: true)
    }
    
    func readPlanetPListWithPath(aPath: String) -> Array <Planet> {
        var arrayFromPList = NSArray(contentsOfFile: aPath)
        var planetArray: Array <Planet> = Array()
        
        if arrayFromPList != nil {
            for planetDict in arrayFromPList! {
                var planet = Planet()
                
                var intValue = planetDict["number"]
                
                planet.number = Int((intValue as NSNumber))
/*                if planet.player != nil {
                    planetDict["player"] = planet.player!.name
                }
                
                var fleetArray: Array <Int> = Array()
                for fleet in planet.fleets {
                    fleetArray.append(fleet.number)
                }
                
                planetDict["fleets"] = fleetArray */
                
                intValue = planetDict["industry"]
                planet.industry = Int((intValue as NSNumber))
                
                intValue = planetDict["metal"]
                planet.metal = Int((intValue as NSNumber))
                
                intValue = planetDict["mines"]
                planet.mines = Int((intValue as NSNumber))
                
                intValue = planetDict["population"]
                planet.population = Int((intValue as NSNumber))
                
                intValue = planetDict["limit"]
                planet.limit = Int((intValue as NSNumber))

                intValue = planetDict["round"]
                planet.round = Int((intValue as NSNumber))

                intValue = planetDict["iShips"]
                planet.iShips = Int((intValue as NSNumber))

                intValue = planetDict["pShips"]
                planet.pShips = Int((intValue as NSNumber))

                planetArray.append(planet)
            }
        }
        return planetArray
    }
}