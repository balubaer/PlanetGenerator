//
//  Tests.swift
//  Tests
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

//import Cocoa
import XCTest

class TestsFleetMovement: XCTestCase {
    var fleet: Fleet = Fleet()
    var planet: Planet = Planet()
    var player: Player = Player()
    
    override func setUp() {
        super.setUp()
        
        player.name = "ZAPHOD"
        fleet.player = player
        fleet.number = 25
        planet.number = 46
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testDescription() {
        var fleetMove = FleetMovement()
        
        fleetMove.fleet = fleet
        fleetMove.toPlanet = planet
        
        XCTAssertEqual("(F25[ZAPHOD]-->W46)", fleetMove.description, "### fleetMove.description Fehler ###")

    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock() {
            // Put the code you want to measure the time of here.
        }
    }
    
}
