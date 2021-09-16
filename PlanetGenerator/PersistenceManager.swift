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
    var allPlayerDict: [String: Player] = Dictionary()

    init(aPlanetArray: Array <Planet>) {
        planetArray = aPlanetArray
    }
    
    init () {
        
    }
    
    func writePlanetPListWithPlanetArray(_ aPath: String) {
        var dictForPList = [String:AnyObject]()
        var planetArrayForPList = [[String:AnyObject]]()
        var portDictForPList = [String:AnyObject]()
        var fleetDictForPList = [String:AnyObject]()
        let playerDictForPList = [String:AnyObject]()

        if planetArray != nil {
            for planet in planetArray! {
                var planetDict = [String: AnyObject]()
                
                planetDict["number"] = planet.number as AnyObject
                planetDict["name"] = planet.name as AnyObject
                if planet.player != nil {
                    planetDict["player"] = planet.player!.name as AnyObject
                    if planet.player!.role == nil {
                        planet.player!.role = Role()
                    }
                   // playerDictForPList[planet.player!.name] = ["points":planet.player!.points, "role": planet.player!.role!.name, "teammates": planet.player!.teanmatesNames]
                }
                
                var fleetArray: Array <Int> = Array()
                for fleet in planet.fleets {
                    var fleetDict = [String: AnyObject]()
                    fleetArray.append(fleet.number)
                    
                    fleetDict["number"] = fleet.number as AnyObject
                    fleetDict["ships"] = fleet.ships as AnyObject
                    if fleet.player != nil {
                        fleetDict["player"] = fleet.player!.name as AnyObject
                    }
                    fleetDict["cargo"] = fleet.cargo as AnyObject
                    fleetDict["moved"] = fleet.moved as AnyObject
                    fleetDictForPList[String(fleet.number)] = fleetDict as AnyObject
                }
                planetDict["fleets"] = fleetArray as AnyObject
                
                if planet.port != nil && planet.port!.planet != nil {
                    var aPlanetsArray: Array <Int> = Array()
                    
                    for planet in planet.port!.planets {
                        aPlanetsArray.append(planet.number)
                    }
                    portDictForPList[String(planet.port!.planet!.number)] = aPlanetsArray as AnyObject
                    //  portDictForPList[String(planet.port!.planet!.number)] = "Hallo"
                }
                planetDict["industry"] = planet.industry as AnyObject
                planetDict["metal"] = planet.metal as AnyObject
                planetDict["mines"] = planet.mines as AnyObject
                planetDict["population"] = planet.population as AnyObject
                planetDict["limit"] = planet.limit as AnyObject
                planetDict["round"] = planet.round as AnyObject
                planetDict["iShips"] = planet.iShips as AnyObject
                planetDict["pShips"] = planet.pShips as AnyObject
                planetDict["dShips"] = planet.dShips as AnyObject
                planetArrayForPList.append(planetDict)
            }
        }
        dictForPList["planets"] = planetArrayForPList as AnyObject
        dictForPList["player"] = playerDictForPList as AnyObject
        dictForPList["ports"] = portDictForPList as AnyObject
        dictForPList["fleets"] = fleetDictForPList as AnyObject
        
        (dictForPList as  NSDictionary).write(toFile: aPath, atomically: true)
    }
    
    func readPlanetPListWithPath(_ aPath: String) -> Array <Planet> {
        var planetArray: Array <Planet> = Array()
        if let dictFormPList = NSDictionary(contentsOfFile: aPath) {
            
            if let playerDictFormPList = dictFormPList["player"] as? Dictionary<String, AnyObject> {
                for (playerName, playerDict) in playerDictFormPList {
                    let player = Player()
                    player.name = playerName
                    if let intValueObject = playerDict["points"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            player.points = intValue
                        }
                    }
                    let role = Role()
                    if let roleName = playerDict["role"] as? String {
                        role.name = roleName
                    }
                    player.role = role
                    
                    allPlayerDict[playerName] = player
                }
                for (playerName, player) in allPlayerDict {
                    if let playerDict = playerDictFormPList[playerName] {
                        if let teammateNames = playerDict["teammates"] as? NSArray {
                            for teammateName in teammateNames {
                                if let player2 = allPlayerDict[teammateName as! String] {
                                    player.teammates.insert(player2)
                                }
                            }
                        }
                    }
                }
            }

            if let planetArrayFormPList = dictFormPList["planets"] as? Array <NSDictionary> {
                for planetDict in planetArrayFormPList {
                    let planet = Planet()
                    
                    if let intValueObject = planetDict["number"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.number = intValue
                        }
                    }

                    if let playerName = planetDict["player"] as? String {
                        planet.player = allPlayerDict[playerName]
                    }
                    
                    if let fleetArray = planetDict["fleets"] as? Array<Int> {
                        for aFleetNumber in fleetArray {
                            //Create a Fleet
                            let fleet = Fleet()
                            fleet.number = aFleetNumber
                            planet.fleets.append(fleet)
                        }
                    }
                    
                    if let intValueObject = planetDict["industry"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.industry = intValue
                        }
                    }

                    if let intValueObject = planetDict["metal"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.metal = intValue
                        }
                    }
                    
                    if let intValueObject = planetDict["mines"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.mines = intValue
                        }
                    }

                    if let intValueObject = planetDict["population"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.population = intValue
                        }
                    }
                    
                    if let intValueObject = planetDict["limit"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.limit = intValue
                        }
                    }
                    
                    if let intValueObject = planetDict["round"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.round = intValue
                        }
                    }
                    
                    if let intValueObject = planetDict["iShips"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.iShips = intValue
                        }
                    }

                    if let intValueObject = planetDict["dShips"] as? NSObject {
                        if let intValue = Int(intValueObject.description) {
                            planet.dShips = intValue
                        }
                    }
                    
                    planetArray.append(planet)
                }
                
                //Set Ports to Planet and complete the Fleets
                for planet in planetArray {
                    //Create a Port
                    let port = Port()
                    port.planet = planet
                    planet.port = port
                    
                    //Get Planets Array from Plist-PortArray
                    if let portDictFormPList = (dictFormPList["ports"] as? Dictionary<String, AnyObject>) {
                        if let intArrayWithPlanetNumbers = portDictFormPList[String(planet.number)] as? Array <NSNumber> {
                            for planetNumber in intArrayWithPlanetNumbers {
                                let aPlanet: Planet? = planetWithNumber(planetArray, number: Int(planetNumber))
                                
                                if aPlanet != nil {
                                    port.planets.append(aPlanet!)
                                }
                            }
                        }
                    }
                    //Complete the Fleets
                    for fleet in planet.fleets {
                        if let fleetDictFormPList = dictFormPList["fleets"] as? Dictionary<String, AnyObject> {
                            if let fleetFromPlist = fleetDictFormPList[String(fleet.number)] as? Dictionary <String, AnyObject> {
                                if let intValueObject = fleetFromPlist["ships"] as? NSObject {
                                    if let intValue = Int(intValueObject.description) {
                                        fleet.ships = intValue
                                    }
                                }

                                if let playerName = fleetFromPlist["player"] as? String {
                                    let player = allPlayerDict[playerName]
                                    if player != nil {
                                        fleet.player = player
                                    }
                                }
                                
                                if let intValueObject = fleetFromPlist["cargo"] as? NSObject {
                                    if let intValue = Int(intValueObject.description) {
                                        fleet.cargo = intValue
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        return planetArray
    }
}
