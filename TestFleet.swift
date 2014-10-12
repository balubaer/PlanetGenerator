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
    }

    
}