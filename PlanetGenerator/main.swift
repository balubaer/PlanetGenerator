//
//  main.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 08.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

var processInfo = ProcessInfo.processInfo
var arguments = processInfo.arguments as NSArray
var programmFilePath = arguments[0] as! NSString
var plistFilePath = programmFilePath.appendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>
var planetCount = Int(truncating: dictFormPList!["planetCount"] as! NSNumber)

var playerNamesFromPlist = Array(dictFormPList!["player"] as! NSArray)
var playerNames: Array <String> = Array()

for playerName in playerNamesFromPlist {
    playerNames.append(String(playerName as! String))
}

var fleetCount = Int(truncating: dictFormPList!["fleetCount"] as! NSNumber)

var fleetsOnHomePlanet = Int(truncating: dictFormPList!["fleetsOnHomePlanet"] as! NSNumber)
var startShipsCount = Int(truncating: dictFormPList!["startShipsCount"] as! NSNumber)
var distanceLevelHomes = Int(truncating: dictFormPList!["distanceLevelHomes"] as! NSNumber)

var playPath = dictFormPList!["playPath"] as! NSString
var playName = dictFormPList!["playName"] as! String

var planets:Array <Planet> = Array()


//Create Planets
for index in 1...planetCount {
    let planet: Planet = Planet()
    
    planet.number = index
    
    planets.append(planet)
}

//Create Ports with PortFactory

var portFactory = PortFactory()

portFactory.moreConnectionPlanet = planetCount/10
portFactory.lessConectionPlanet = planetCount/10
portFactory.createWithPlanetArray(planets)


var fleetFactory = FleetFactory(aFleetCount: fleetCount)

fleetFactory.createWithPlanetArray(planets)

var playerFactory = PlayerFactory(aPlayerNameArray: playerNames)

playerFactory.createWithPlanetArray(planets, fleetCount: fleetCount, aFleetsOnHomePlanet: fleetsOnHomePlanet, startShipsCount: startShipsCount, distanceLevelHomes: distanceLevelHomes)

var planetPlistFilePath = playPath.appendingPathComponent(playName)

var fileManager = FileManager.default

var isDir : ObjCBool = false

if fileManager.fileExists(atPath: planetPlistFilePath, isDirectory: &isDir) == false {
    do {
        try fileManager.createDirectory(atPath: planetPlistFilePath, withIntermediateDirectories: true, attributes: nil)
    } catch {
        NSLog("Fehler createDirectoryAtPath")
    }
}

var planetPlistFilePathTurn = planetPlistFilePath as NSString

planetPlistFilePath = planetPlistFilePathTurn.appendingPathComponent("Turn0")

if fileManager.fileExists(atPath: planetPlistFilePath, isDirectory: &isDir) == false {
    try fileManager.createDirectory(atPath: planetPlistFilePath, withIntermediateDirectories: true, attributes: nil)
}

planetPlistFilePathTurn = planetPlistFilePath as NSString

planetPlistFilePath = planetPlistFilePathTurn.appendingPathComponent("Turn0.plist")

var persManager = PersistenceManager(aPlanetArray:planets)
persManager.writePlanetPListWithPlanetArray(planetPlistFilePath)


