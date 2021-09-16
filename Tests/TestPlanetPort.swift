//
//  PlanetPortTest.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestPlanetPort: XCTestCase {
    
    func testDescription() {
        let planet = Planet()
        let port = Port()
        
        XCTAssertEqual("W0", planet.description, "### planet.description Fehler ###")

        planet.number = 123
        XCTAssertEqual("W123", planet.description, "### planet.description Fehler ###")
        XCTAssertEqual("W?", port.description, "### port.description Fehler ###")

        planet.port = port
        port.planet = planet
        
        XCTAssertEqual("W123", planet.description, "### planet.description Fehler ###")
        XCTAssertEqual("W123", port.description, "### port.description Fehler ###")
        
        let planet1 = Planet()
        planet1.number = 1
        
        port.planets.append(planet1)
        XCTAssertEqual("W123(1)", port.description, "### port.description Fehler ###")

        let planet2 = Planet()
        planet2.number = 2

        port.planets.append(planet2)
        XCTAssertEqual("W123(1,2)", port.description, "### port.description Fehler ###")

        let planet3 = Planet()
        planet3.number = 3

        port.planets.append(planet3)
        XCTAssertEqual("W123(1,2,3)", port.description, "### port.description Fehler ###")
        XCTAssertEqual("W123(1,2,3)", planet.description, "### planet.description Fehler ###")
        
        planet.industry = 1
        XCTAssertEqual("W123(1,2,3) (Industrie=1)", planet.description, "### planet.description Fehler ###")
        
        planet.population = 2
        XCTAssertEqual("W123(1,2,3) (Industrie=1,Bevoelkerung=2)", planet.description, "### planet.description Fehler ###")
        
        planet.limit = 3
        XCTAssertEqual("W123(1,2,3) (Industrie=1,Bevoelkerung=2,Limit=3)", planet.description, "### planet.description Fehler ###")
        
        let player = Player()
        player.name = "ZAPHOD"
        planet.player = player
        
        XCTAssertEqual("W123(1,2,3) [ZAPHOD] (Industrie=1,Bevoelkerung=2,Limit=3)", planet.description, "### planet.description Fehler ###")

        let port1 = Port()
        port1.planet = planet1
        port1.planets.append(planet)
        planet1.port = port1
        planet1.limit = 4
        planet1.mines = 5
        XCTAssertEqual("W1(123) (Minen=5,Limit=4)", planet1.description, "### planet.description Fehler ###")
        
        
        

    }
}
