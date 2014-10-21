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
    var commandStrings: Array <String>
    var processCommand: String?
    var commandChars: String?
    var commandElements: Array <String>
    
    init(aPlanetArray: Array <Planet>) {
        planets = aPlanetArray
        commandStrings = Array()
        commandElements = Array()
    }
    
    func setCommandStringsWithLongString(aString: String) {
        commandStrings = aString.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: " \n\r"))
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
        return BuildFleetShip(aFleet: bulidParameterForFleet.fleet, aHomePlanet: bulidParameterForFleet.homePlanet, aPlanetNumber: bulidParameterForFleet.planetNumber,  aShipsToBuild: bulidParameterForFleet.shipsToBuild, aString: processCommand!, aPlayer: Player())
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
        return MoveCommand(aFleet: fleetAndPlanets.fleet, aHomePlanet:fleetAndPlanets.homePlanet, aPlanetArray: fleetAndPlanets.planetArray, aString: processCommand!, aPlayer: Player())
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
                default:
                    result = nil
                }
            }
        }
        return result
    }
    
    func executeCommands() {
        var commandArray:Array <Command> = Array()
        
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
            var commandInstance:AnyObject? = self.getCommandInstance()
            if commandInstance != nil {
                if commandInstance is Command {
                    commandArray.append(commandInstance as Command)
                }
            }
        }
        
        commandArray.sort { $0 < $1 }
        
        for command in commandArray {
            (command as ExecuteCommand).executeCommand()
        }
    }
}
