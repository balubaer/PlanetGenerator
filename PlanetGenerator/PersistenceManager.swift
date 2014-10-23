//
//  PersistenceManager.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 15.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class PersistenceManager {
    
    var planetArray: Array <Planet>?
    
    init(aPlanetArray: Array <Planet>) {
        planetArray = aPlanetArray
    }
    
    init () {
        
    }
    
    func writePlanetPListWithPlanetArray(aPath: String) {
        var dictForPList = [String:AnyObject]()
        var planetArrayForPList = [[String:AnyObject]]()
        var portDictForPList = [String:AnyObject]()
        var fleetDictForPList = [String:AnyObject]()
        var playerDictForPList = [String:AnyObject]()

        var TestList = [Int]()
        
        if planetArray != nil {
            for planet in planetArray! {
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
                    fleetDict["ambush"] = fleet.ambush
                    fleetDictForPList[String(fleet.number)] = fleetDict
                }
                planetDict["fleets"] = fleetArray
                
                if planet.port != nil && planet.port!.planet != nil {
                    var aPlanetsArray: Array <Int> = Array()
                    
                    for planet in planet.port!.planets {
                        aPlanetsArray.append(planet.number)
                    }
                    portDictForPList[String(planet.port!.planet!.number)] = aPlanetsArray
                    //  portDictForPList[String(planet.port!.planet!.number)] = "Hallo"
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
        }
        dictForPList["planets"] = planetArrayForPList
        dictForPList["player"] = playerDictForPList
        dictForPList["ports"] = portDictForPList
        dictForPList["fleets"] = fleetDictForPList
        
        (dictForPList as  NSDictionary).writeToFile(aPath, atomically: true)
    }
    
    func readPlanetPListWithPath(aPath: String) -> Array <Planet> {
        // if let dict = NSDictionary(contentsOfFile: path) as? Dictionary<String, AnyObject>
        var dictFormPList = NSDictionary(contentsOfFile: aPath) as? Dictionary<String, AnyObject>
        var planetArrayFormPList:Array? = (dictFormPList!["planets"] as NSArray)
        var portDictFormPList = (dictFormPList!["ports"] as? Dictionary<String, AnyObject>)
        var fleetDictFormPList = dictFormPList?["fleets"] as? Dictionary<String, AnyObject>
       // var playerDictFormPList:AnyObject? = dictFormPList?.objectForKey("player")
        var playerDictFormPList = dictFormPList?["player"] as? Dictionary<String, AnyObject>
        
        var planetArray: Array <Planet> = Array()
        var portConnections: [Int: Array<Int>] = Dictionary()
        
        if planetArrayFormPList != nil {
            for planetDict in planetArrayFormPList! {
                var planet = Planet()
                
                var intValue = planetDict["number"]
                
                planet.number = Int((intValue as NSNumber))
                
                var playerName:String? = planetDict["player"] as String?
                
                if playerName != nil {
                    var playerDict = playerDictFormPList![playerName!] as? Dictionary<String, AnyObject>
                    //TODO: player
                }
                
                var fleetArray: Array<Int>? = planetDict["fleets"] as? Array<Int>
                
                if fleetArray != nil {
                    for aFleetNumber in fleetArray! {
                        //Create a Fleet
                        var fleet = Fleet()
                        fleet.number = aFleetNumber
                        planet.fleets.append(fleet)
                    }
                }
                
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
            //Set Ports to Planet and complete the Fleets
            for planet in planetArray {
                //Create a Port
                var port = Port()
                port.planet = planet
                planet.port = port
                
                //Get Planets Array from Plist-PortArray
                var intArrayWithPlanetNumbers = portDictFormPList![String(planet.number)] as Array <NSNumber>
                
                for planetNumber in intArrayWithPlanetNumbers {
                    var aPlanet: Planet? = planetWithNumber(planetArray, Int(planetNumber))
                    
                    if aPlanet != nil {
                        port.planets.append(aPlanet!)
                    }
                }
                
                //Complete the Fleets
                for fleet in planet.fleets {
                    var fleetFromPlist = fleetDictFormPList![String(fleet.number)] as? Dictionary <String, AnyObject>
                    if fleetFromPlist != nil {
                        fleet.ships = Int(fleetFromPlist!["ships"] as NSNumber)
                        
                        var playerName:String? = fleetFromPlist!["player"] as String?
                        
                        if playerName != nil {
                            var playerDict = playerDictFormPList![playerName!] as? Dictionary<String, AnyObject>
                            //TODO: player
                        }
                        fleet.cargo = Int(fleetFromPlist!["cargo"] as NSNumber)
                        fleet.moved = (fleetFromPlist!["moved"] as Bool)
                        fleet.ambush = (fleetFromPlist!["ambush"] as Bool)
                    }
                }
            }
        }
        return planetArray
    }
}