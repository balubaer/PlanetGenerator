//
//  main.swift
//  OutPutLists
//
//  Created by Bernd Niklas on 24.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

var processInfo = ProcessInfo.processInfo
var arguments = processInfo.arguments
var programmFilePath = arguments[0] as NSString
var plistFilePath = programmFilePath.appendingPathExtension("plist")

var dictFormPList = NSDictionary(contentsOfFile: plistFilePath!) as? Dictionary<String, AnyObject>

var playPath = dictFormPList!["playPath"] as! NSString
var playName = dictFormPList!["playName"] as! String

var turnNumber = Int(dictFormPList!["turn"] as! NSNumber)

var turnPath = playPath.appendingPathComponent(playName) as NSString


turnPath = turnPath.appendingPathComponent("Turn\(turnNumber)") as NSString

var planetPlistFilePath = turnPath.appendingPathComponent("Turn\(turnNumber).plist")

var fileManager = FileManager.default

var isDir : ObjCBool = false

if fileManager.fileExists(atPath: planetPlistFilePath, isDirectory: &isDir) == false {
    NSLog("Fehler: Planeten File \(planetPlistFilePath) ist nicht vorhanden!!!")
}

var persManager = PersistenceManager()
var planets = persManager.readPlanetPListWithPath(planetPlistFilePath)

var allPlayerDict = persManager.allPlayerDict


//output Result
for (playerName, player) in allPlayerDict {
    var xmlRoot = XMLElement(name: "report");
    if let attribute = XMLNode.attribute(withName: "changeSeq", stringValue: "1") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "endCondition", stringValue: "score:None") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "gameId", stringValue: playName) as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "parametersName", stringValue: "Core") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "parametersToken", stringValue: "core") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "rsw", stringValue: "False") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    if let attribute = XMLNode.attribute(withName: "turnNumber", stringValue: "\(turnNumber + 1)") as? XMLNode {
        xmlRoot.addAttribute(attribute)
    }
    
    var childElementPlayer = player.getXMLElement()
    if let attribute = XMLNode.attribute(withName: "lastInvolvedTurn", stringValue: "1") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "lastPlayedTurn", stringValue: "1") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "type", stringValue: "Core") as? XMLNode {
        childElementPlayer.addAttribute(attribute)
    }
    if let attribute = XMLNode.attribute(withName: "typeKey", stringValue: "core") as? XMLNode {
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
    var outPutFilePath = turnPath.appendingPathComponent("\(playerName).out")
    try outPutString.write(toFile: outPutFilePath, atomically: true, encoding: String.Encoding.utf8)
    
    if let xmlReport = XMLDocument.document(withRootElement: xmlRoot) as? XMLDocument{
        var outPutFilePathXML = outPutFilePath as NSString
        xmlReport.version = "1.0"
        xmlReport.characterEncoding = "UTF-8"
       // var xmlData = xmlReport.XMLDataWithOptions(Int(NSXMLNodePrettyPrint))
        //var xmlData = xmlReport.XMLData
        outPutFilePathXML = outPutFilePathXML.deletingPathExtension as NSString
        if let outPutXMLFilePath = outPutFilePathXML.appendingPathExtension("xml") {
          //  xmlData.writeToFile(outPutXMLFilePath, atomically: true)
        }
    }
    
}


