//
//  CommandFactory.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class CommandFactory {
    var planets: Array <Planet>
    var commandStringsDict: Dictionary <String, Array <String>>
    var processCommand: String?
    var commandChars: String?
    var commandPlayer: Player?
    var commandElements: Array <String>
    var allPlayerDict: [String: Player]
    var coreGame: Bool = false

    init(aPlanetArray: Array <Planet>, aAllPlayerDict: [String: Player]) {
        planets = aPlanetArray
        allPlayerDict = aAllPlayerDict
        commandStringsDict = Dictionary()
        commandElements = Array()
    }
    
    func setCommandStringsWithLongString(playerName:String, commandString: String) {
        commandStringsDict[playerName] = commandString.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: " \n\r"))
    }

    //WnnnBqqqFmmm
    
    func findBuildParameterForFleet() -> (fleet: Fleet, homePlanet:Planet, planetNumber: Int, shipsToBuild: Int) {
        var counter = 0
        var planetNumber = 0
        var shipsToBuild = 0
        var fleet: Fleet = Fleet()
        var homePlanet: Planet = Planet()

        for commantElement in commandElements {
            if counter == 0 {
                var aPlanetNumber = extractNumberString(commantElement).toInt()
                if aPlanetNumber != nil {
                    planetNumber = aPlanetNumber!
                }
            } else if counter == 1 {
                var aShipsToBuild = extractNumberString(commantElement).toInt()
                if aShipsToBuild != nil {
                    shipsToBuild = aShipsToBuild!
                }
            } else {
                var fleetNumber: Int? = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fleet = aFleetAndHomePlanet.fleet!
                        homePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter++
        }
        return (fleet, homePlanet, planetNumber, shipsToBuild)
    }
    
    func createBuildFleetShipCommand() -> BuildFleetShip {
        var bulidParameterForFleet = findBuildParameterForFleet()
        return BuildFleetShip(aFleet: bulidParameterForFleet.fleet, aHomePlanet: bulidParameterForFleet.homePlanet, aPlanetNumber: bulidParameterForFleet.planetNumber,  aShipsToBuild: bulidParameterForFleet.shipsToBuild, aString: processCommand!, aPlayer: commandPlayer!)
    }

    //FnnnUqqq FnnnU
    func findParameterForUnloadingMetal() -> (fleet: Fleet, homePlanet:Planet, metalToUnload: Int) {
        var counter = 0
        var metalToUnload = 0
        var fleet: Fleet = Fleet()
        var homePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                var fleetNumber: Int? = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fleet = aFleetAndHomePlanet.fleet!
                        homePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                var aMetalToUnload = extractNumberString(commantElement).toInt()
                if aMetalToUnload != nil {
                    metalToUnload = aMetalToUnload!
                }
            }
            counter++
        }
        return (fleet, homePlanet, metalToUnload)
    }
    
    func createUnloadingMetalCommand() -> UnloadingMetal {
        var parameterForUnlodingMetal = findParameterForUnloadingMetal()
        return UnloadingMetal(aFleet: parameterForUnlodingMetal.fleet, aHomePlanet: parameterForUnlodingMetal.homePlanet,  aMetalToUnload: parameterForUnlodingMetal.metalToUnload, aString: processCommand!, aPlayer: commandPlayer!)
    
    }
    
    // FnnnWmmm FnnnWmmmWooo FnnnWmmmWoooWrrr
    func findFleetAndPlanets() -> (fleet: Fleet, homePlanet:Planet, planetArray: Array <Planet>) {
        var fleet: Fleet = Fleet()
        var homePlanet: Planet = Planet()
        var planetArray: Array <Planet> = Array()
        var counter = 0
        
        for commantElement in commandElements {
            if counter == 0 {
                var fleetNumber: Int? = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fleet = aFleetAndHomePlanet.fleet!
                        homePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else {
                var planetNumber: Int? = extractNumberString(commantElement).toInt()
                if planetNumber != nil {
                    var planet = planetWithNumber(planets, planetNumber!)
                    
                    if planet != nil {
                        planetArray.append(planet!)
                    }
                }
            }
            counter++
        }
        return (fleet, homePlanet, planetArray)
    }
    
    func createMoveCommand() -> MoveCommand {
        var fleetAndPlanets = findFleetAndPlanets()
        return MoveCommand(aFleet: fleetAndPlanets.fleet, aHomePlanet:fleetAndPlanets.homePlanet, aPlanetArray: fleetAndPlanets.planetArray, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findFromFleetToFleetAndPlanets() -> (fromFleet: Fleet, toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet, shipsToTransfer: Int) {
        var counter = 0
        var shipsToTransfer = 0
        var fromFleet: Fleet = Fleet()
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                var fleetNumber = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                var aShipsToTransfer = extractNumberString(commantElement).toInt()
                if aShipsToTransfer != nil {
                    shipsToTransfer = aShipsToTransfer!
                }
            } else {
                var fleetNumber: Int? = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter++
        }
        return (fromFleet, toFleet, fromHomePlanet, toHomePlanet, shipsToTransfer)
    }
    
    func createTransferShipsFleetToFleetCommand() -> TransferShipsFleetToFleet {
        var fromFleetToFleetAndPlanets = findFromFleetToFleetAndPlanets()
        return TransferShipsFleetToFleet(aFromFleet: fromFleetToFleetAndPlanets.fromFleet, aToFleet: fromFleetToFleetAndPlanets.toFleet, aFromHomePlanet: fromFleetToFleetAndPlanets.fromHomePlanet, aToHomePlanet: fromFleetToFleetAndPlanets.toHomePlanet, aShipsToTransfer: fromFleetToFleetAndPlanets.shipsToTransfer, aString: processCommand!, aPlayer: commandPlayer!)
    }
    func findFromFleetToDShipsAndPlanet() -> (fromFleet: Fleet, fromHomePlanet:Planet, shipsToTransfer: Int) {
        var counter = 0
        var fromFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var shipsToTransfer = 0

        for commantElement in commandElements {
            if counter == 0 {
                var fleetNumber = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                var aShipsToTransfer = extractNumberString(commantElement).toInt()
                if aShipsToTransfer != nil {
                    shipsToTransfer = aShipsToTransfer!
                }
            }
            
            counter++
        }
        return (fromFleet, fromHomePlanet, shipsToTransfer)
    }

    func createTransferShipsFleetToDShipsCommand() -> TransferShipsFleetToDShips {
        var fromFleetToDShipsAndPlanet = findFromFleetToDShipsAndPlanet()
        return TransferShipsFleetToDShips(aFromFleet: fromFleetToDShipsAndPlanet.fromFleet, aFromHomePlanet: fromFleetToDShipsAndPlanet.fromHomePlanet, aShipsToTransfer: fromFleetToDShipsAndPlanet.shipsToTransfer, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findTransferDShipsToFleetAndPlanets() -> (toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet, shipsToTransfer: Int) {
        var counter = 0
        var shipsToTransfer = 0
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                var planetNumber = extractNumberString(commantElement).toInt()
                if planetNumber != nil {
                    fromHomePlanet = planetWithNumber(planets, planetNumber!) as Planet!
                }
            } else if counter == 1 {
                var aShipsToTransfer = extractNumberString(commantElement).toInt()
                if aShipsToTransfer != nil {
                    shipsToTransfer = aShipsToTransfer!
                }
            } else {
                var fleetNumber: Int? = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter++
        }
        return (toFleet, fromHomePlanet, toHomePlanet, shipsToTransfer)
    }

    func createTransferDShipsToFleetCommand() -> TransferDShipsToFleet {
        var transferDShipsToFleetAndPlanets = findTransferDShipsToFleetAndPlanets()
        return TransferDShipsToFleet(aToFleet: transferDShipsToFleetAndPlanets.toFleet, aFromHomePlanet: transferDShipsToFleetAndPlanets.fromHomePlanet, aToHomePlanet: transferDShipsToFleetAndPlanets.toHomePlanet, aShipsToTransfer: transferDShipsToFleetAndPlanets.shipsToTransfer, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findFromFleetFireToFleetAndPlanets() -> (fromFleet: Fleet, toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet) {
        var counter = 0
        var fromFleet: Fleet = Fleet()
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                var fleetNumber = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            } else if counter == 1 {
                //Nichts zu tun
            } else {
                var fleetNumber: Int? = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter++
        }
        return (fromFleet, toFleet, fromHomePlanet, toHomePlanet)
    }

    func createFireFleetToFleetCommand() -> FireFleetToFleet {
        var fromFleetFireToFleetAndPlanets = findFromFleetFireToFleetAndPlanets()
        return FireFleetToFleet(aFromFleet: fromFleetFireToFleetAndPlanets.fromFleet, aToFleet: fromFleetFireToFleetAndPlanets.toFleet, aFromHomePlanet: fromFleetFireToFleetAndPlanets.fromHomePlanet, aToHomePlanet: fromFleetFireToFleetAndPlanets.toHomePlanet, aString: processCommand!, aPlayer: commandPlayer!)
    }
    
    func findFromFleetFireToDShipsAndPlanets() -> (fromFleet: Fleet, fromHomePlanet:Planet) {
        var counter = 0
        var fromFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                var fleetNumber = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        fromFleet = aFleetAndHomePlanet.fleet!
                        fromHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter++
        }
        return (fromFleet, fromHomePlanet)
    }

    func createFireFleetToDShipsCommand() -> FireFleetToDShips {
        var fromFleetFireToDShipsAndPlanets = findFromFleetFireToDShipsAndPlanets()
       return FireFleetToDShips(aFromFleet: fromFleetFireToDShipsAndPlanets.fromFleet, aFromHomePlanet: fromFleetFireToDShipsAndPlanets.fromHomePlanet, aString: processCommand!, aPlayer: commandPlayer!)
    }

    func findFromDShipsFireToFleetAndPlanets() -> (toFleet: Fleet, fromHomePlanet:Planet, toHomePlanet:Planet) {
        var counter = 0
        var toFleet: Fleet = Fleet()
        var fromHomePlanet: Planet = Planet()
        var toHomePlanet: Planet = Planet()
        
        for commantElement in commandElements {
            if counter == 0 {
                var planetNumber = extractNumberString(commantElement).toInt()
                if planetNumber != nil {
                    fromHomePlanet = planetWithNumber(planets, planetNumber!) as Planet!
                }
            } else if counter == 1 {
                //Nichts zu tun
            } else {
                var fleetNumber: Int? = extractNumberString(commantElement).toInt()
                if fleetNumber != nil {
                    var aFleetAndHomePlanet = fleetAndHomePlanetWithNumber(planets, fleetNumber!)
                    if aFleetAndHomePlanet.fleet != nil && aFleetAndHomePlanet.homePlanet != nil {
                        toFleet = aFleetAndHomePlanet.fleet!
                        toHomePlanet = aFleetAndHomePlanet.homePlanet!
                    }
                }
            }
            counter++
        }
        return (toFleet, fromHomePlanet, toHomePlanet)
    }

    func createFireDShipsToFleetCommand() -> FireDShipsToFleet {
        var fromDShipsFireToFleetAndPlanets = findFromDShipsFireToFleetAndPlanets()
        return FireDShipsToFleet(aToFleet: fromDShipsFireToFleetAndPlanets.toFleet, aFromHomePlanet: fromDShipsFireToFleetAndPlanets.fromHomePlanet, aToHomePlanet: fromDShipsFireToFleetAndPlanets.toHomePlanet, aString: processCommand!, aPlayer: commandPlayer!)
    }

    func getCommandInstance() -> AnyObject? {
        var result: AnyObject? = nil
        if commandChars != nil {
            var characterArray: Array <Character> = Array(commandChars!)
            
            if characterArray.count >= 2 {
                switch characterArray[0] {
                case "F":
                    switch characterArray[1] {
                    case "W":
                        result = createMoveCommand()
                    case "U":
                        result = createUnloadingMetalCommand()
                    case "T":
                        if characterArray.count == 3 {
                            switch characterArray[2] {
                            case "F":
                                result = createTransferShipsFleetToFleetCommand()
                            case "D":
                                result = createTransferShipsFleetToDShipsCommand()
                            default:
                                result = nil
                            }
                        }
                    case "A":
                        if characterArray.count == 3 {
                            switch characterArray[2] {
                            case "F":
                                result = createFireFleetToFleetCommand()
                            case "D":
                                result = createFireFleetToDShipsCommand()
                            default:
                                result = nil
                                
                            }
                        }
                    default:
                        result = nil
                    }
                case "W":
                    switch characterArray[1] {
                    case "B":
                        if characterArray.count == 3 {
                            if characterArray[2] == "F" {
                                result = createBuildFleetShipCommand()
                            }
                        }
                    default:
                        result = nil
                    }
                case "D":
                    switch characterArray[1] {
                    case "A":
                        if characterArray.count == 3 {
                            if characterArray[2] == "F" {
                                result = createFireDShipsToFleetCommand()
                            }
                        }
                    case "T":
                        if characterArray.count == 3 {
                            if characterArray[2] == "F" {
                                result = createTransferDShipsToFleetCommand()
                            }
                        }
                    default:
                        result = nil
                    }
                default:
                    result = nil
                }
            }
        }
        return result
    }
    
    func executeCommands() {
        var commandArray:Array <Command> = Array()
        
        for (playerName, commandStrings) in commandStringsDict {
            for command in commandStrings {
                commandChars = ""
                processCommand = command
                commandElements = Array()
                var counter = 0
                var charCount = countElements(command)
                var foundCommandElementEnd = false
                var commandElement = String()
                
                for character in command as String {
                    
                    if isCharacterANumber(character) == false {
                        commandChars?.append(character)
                        if counter != 0 {
                            foundCommandElementEnd = true
                        }
                        if foundCommandElementEnd {
                            commandElements.append(commandElement)
                            commandElement = String()
                            foundCommandElementEnd = false
                        }
                        commandElement.append(character)
                    } else {
                        commandElement.append(character)
                    }
                    counter++
                    if counter == charCount {
                        commandElements.append(commandElement)
                    }
                }
                commandPlayer = allPlayerDict[playerName]
                var commandInstance:AnyObject? = self.getCommandInstance()
                if commandInstance != nil {
                    if commandInstance is Command {
                        commandArray.append(commandInstance as Command)
                    }
                }
            }
        }
        
        if coreGame {
            for (playerName, player) in allPlayerDict {
                var buildDShips = BuildDShips(aPlanetArray: planets, aPlayer: player)
                commandArray.append(buildDShips as Command)
            }
        }
        
        commandArray.sort { $0 < $1 }
        
        for command in commandArray {
            (command as ExecuteCommand).executeCommand()
        }
    }
}
