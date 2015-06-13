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
var programmFilePath = arguments[0] as! String
var plistFilePath = programmFilePath.stringByAppendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>

var playPath = dictFormPList!["playPath"] as! String
var playName = dictFormPList!["playName"] as! String

var turnNumber = Int(dictFormPList!["turn"] as! NSNumber)

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
    var xmlRoot = NSXMLElement(name: "report");
    if let attribute = NSXMLNode.attributeWithName("changeSeq", stringValue: "1") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("endCondition", stringValue: "score:None") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("gameId", stringValue: playName) as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("parametersName", stringValue: "Core") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("parametersToken", stringValue: "core") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("rsw", stringValue: "False") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    if let attribute = NSXMLNode.attributeWithName("turnNumber", stringValue: "\(turnNumber + 1)") as? NSXMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    var childElementPlayer = player.getXMLElement()
    if let attribute = NSXMLNode.attributeWithName("lastInvolvedTurn", stringValue: "1") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("lastPlayedTurn", stringValue: "1") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("type", stringValue: "Core") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = NSXMLNode.attributeWithName("typeKey", stringValue: "core") as? NSXMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    xmlRoot.addChild(childElementPlayer)

    var outPutString = "Infos zu Spieler: \(playerName) Runde: \(turnNumber + 1)\n\n"
    for planet in planets {
        if Player.isPlanetOutPutForPlayer(player, planet: planet) {
            var childElementPlanet = planet.getXMLElementForPlayer(player)
            xmlRoot.addChild(childElementPlanet)

            outPutString += "\(planet.description)\n\n"
        }
    }
    var outPutFilePath = turnPath.stringByAppendingPathComponent("\(playerName).out")
    outPutString.writeToFile(outPutFilePath, atomically: true, encoding: NSUTF8StringEncoding, error: nil)
    
    if let xmlReport = NSXMLDocument.documentWithRootElement(xmlRoot) as? NSXMLDocument{
        xmlReport.version = "1.0"
        xmlReport.characterEncoding = "UTF-8"
        var xmlData = xmlReport.XMLDataWithOptions(Int(NSXMLNodePrettyPrint))
        //var xmlData = xmlReport.XMLData
        outPutFilePath = outPutFilePath.stringByDeletingPathExtension
        if let outPutXMLFilePath = outPutFilePath.stringByAppendingPathExtension("xml") {
            xmlData.writeToFile(outPutXMLFilePath, atomically: true)
        }
    }
    
}


