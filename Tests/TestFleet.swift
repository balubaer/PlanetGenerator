//
//  TestFleet.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestFleets: XCTestCase {
    
    func testName() {
        var fleet = Fleet()
        XCTAssertEqual("F0[---]", fleet.name, "### fleet.name Fehler ###")
        
        var player = Player()
        player.name = "ZAPHOD"
        fleet.player = player
        fleet.number = 25
        
        XCTAssertEqual("F25[ZAPHOD]", fleet.name, "### fleet.name Fehler ###")


    }
    
    func testdescription() {
        var fleet = Fleet()
        XCTAssertEqual("F0[---] = 0", fleet.description, "### fleet.description Fehler ###")
        
        var player = Player()
        player.name = "ZAPHOD"
        fleet.player = player
        fleet.ships = 99
        fleet.number = 25
        
        XCTAssertEqual("F25[ZAPHOD] = 99", fleet.description, "### fleet.description Fehler ###")
        
        var fleetMovement = FleetMovement()
        fleet.fleetMovements.append(fleetMovement)
        fleet.cargo = 7
        XCTAssertEqual("F25[ZAPHOD] = 99 (bewegt,Fracht=7)", fleet.description, "### fleet.description Fehler ###")

        fleet.fleetMovements.removeAll()
        fleet.ambush = true
        fleet.cargo = 0
        XCTAssertEqual("F25[ZAPHOD] = 99 (Ambush)", fleet.description, "### fleet.description Fehler ###")
        
    }

    
}