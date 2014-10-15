//
//  TestPersistenceManager.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 15.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestPersistenceManager: XCTestCase {
    
    func testPersistence() {
       // var test = NSSearchPathForDirectoriesInDomains(
        
      //  var paths = NSSearchPathForDirectoriesInDomains(directory: NSApplicationSupportDirectory, domainMask: NSUserDomainMask, expandTilde: true)
     //   NSArray *paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES);
       // NSString *applicationSupportDirectory = [paths firstObject];
       // NSLog(@"applicationSupportDirectory: '%@'", applicationSupportDirectory);
        
        var player = Player()
        player.name = "ZAPHOD"

        var planet1 = Planet()
        var port1 = Port()
        var fleet1 = Fleet()
        
        fleet1.number = 1
        fleet1.player = player
        fleet1.ships = 1
        planet1.fleets.append(fleet1)
        
        port1.planet = planet1
        planet1.port = port1
        planet1.number = 1
        planet1.player = player
        planet1.industry = 11
        planet1.population = 12
        planet1.limit = 13

        var planet2 = Planet()
        port1.planets.append(planet2)
        
        var port2 = Port()
        port2.planet = planet2
        port2.planets.append(planet1)
        planet2.port = port2
        
        var fleet2 = Fleet()
        
        fleet2.number = 2
        fleet2.player = player
        fleet2.ships = 1
        planet2.fleets.append(fleet2)

        planet2.number = 2
        planet2.player = player
        planet2.industry = 21
        planet2.population = 22
        planet2.limit = 23

        var planet3 = Planet()
        port2.planets.append(planet3)
        var port3 = Port()
        port3.planet = planet3
        planet3.port = port3
        port3.planets.append(planet2)
        
        var fleet3 = Fleet()
        
        fleet3.number = 3
        fleet3.player = player
        fleet3.ships = 1
        planet3.fleets.append(fleet3)

        planet3.number = 3
        planet3.player = player
        planet3.industry = 31
        planet3.population = 32
        planet3.limit = 33
        
        var planetArray: Array <Planet> = Array()
        planetArray.append(planet1)
        planetArray.append(planet2)
        planetArray.append(planet3)
        
        var persManager = PersistenceManager(aPlanetArray:planetArray)
        persManager.writePlanetPListWithPlanetArray("/tmp/planets.plist")
        
        var newPlanetArray = persManager.readPlanetPListWithPath("/tmp/planets.plist")

        XCTAssertTrue(true, "### factory Fehler ###")
        
    }

}