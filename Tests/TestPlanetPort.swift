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
        var planet = Planet()
        var port = Port()
        
        XCTAssertEqual("W0", planet.description, "### planet.description Fehler ###")

        planet.number = 123
        XCTAssertEqual("W123", planet.description, "### planet.description Fehler ###")
        XCTAssertEqual("W?", port.description, "### port.description Fehler ###")

        planet.ports = port
        port.planet = planet
        
        XCTAssertEqual("W123", planet.description, "### planet.description Fehler ###")
        XCTAssertEqual("W123", port.description, "### port.description Fehler ###")
        
        var planet1 = Planet()
        planet1.number = 1
        
        port.planets.append(planet1)
        XCTAssertEqual("W123(1)", port.description, "### port.description Fehler ###")

        var planet2 = Planet()
        planet2.number = 2

        port.planets.append(planet2)
        XCTAssertEqual("W123(1,2)", port.description, "### port.description Fehler ###")

        var planet3 = Planet()
        planet3.number = 3

        port.planets.append(planet3)
        XCTAssertEqual("W123(1,2,3)", port.description, "### port.description Fehler ###")
        XCTAssertEqual("W123(1,2,3)", planet.description, "### planet.description Fehler ###")

    }

}