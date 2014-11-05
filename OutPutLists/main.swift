//
//  main.swift
//  OutPutLists
//
//  Created by Bernd Niklas on 24.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

var processInfo = NSProcessInfo.processInfo()
var arguments = processInfo.arguments
var programmFilePath = arguments[0] as String
var plistFilePath = programmFilePath.stringByAppendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>

var playPath = dictFormPList!["playPath"] as String
var playName = dictFormPList!["playName"] as String

var turnNumber = Int(dictFormPList!["turn"] as NSNumber)

var turnPath = playPath.stringByAppendingPathComponent(playName)


turnPath = turnPath.stringByAppendingPathComponent("Turn\(turnNumber)")

var planetPlistFilePath = turnPath.stringByAppendingPathComponent("Turn\(turnNumber).plist")

var fileManager = NSFileManager.defaultManager()

var isDir : ObjCBool = false

if fileManager.fileExistsAtPath(planetPlistFilePath, isDirectory: &isDir) == false {
    NSLog("Fehler: Planeten File \(planetPlistFilePath) ist nicht vorhanden!!!")
}

var persManager = PersistenceManager()
var planets = persManager.readPlanetPListWithPath(planetPlistFilePath)

var allPlayerDict = persManager.allPlayerDict


//output Result
for (playerName, player) in allPlayerDict {
    var outPutString = "Infos zu Spieler: \(playerName) Runde: \(turnNumber)\n\n"
    for planet in planets {
        if Player.isPlayOnPlanet(player, planet: planet) {
            outPutString += "\(planet.description)\n\n"
        }
    }
    var outPutFilePath = turnPath.stringByAppendingPathComponent("\(playerName).out")
    outPutString.writeToFile(outPutFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
}


