//
//  TestPlayer.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation
import XCTest

class TestPlayer: XCTestCase {
    
    func testName() {
        var player = Player()
        player.name = "ZAPHOD"
        
        XCTAssertEqual("ZAPHOD", player.name, "### player.name Fehler ###")
        
        
    }
    
    func testdescription() {
        var player = Player()
        player.name = "ZAPHOD"
        
        XCTAssertEqual("[ZAPHOD]", player.description, "### player.description Fehler ###")
    }
    
    func testIsPlayerInFleetsWithPlayer() {
        var player = Player()
        
        player.name = "Test"

        var fleets: Array <Fleet> = Array()
        var fleet = Fleet()
        
        fleet.number = 1
        
        fleets.append(fleet)
        
        fleet = Fleet()
        fleet.number = 2
        fleet.player = player
        fleets.append(fleet)

        
        XCTAssertTrue(Player.isPlayerInFleetsWithPlayer(player, fleets: fleets), "### Player.isPlayerInFleetsWithPlayer liefert falsches Ergebnis ###")
        
        player = Player()
        player.name = "Test2"
        XCTAssertFalse(Player.isPlayerInFleetsWithPlayer(player, fleets: fleets), "### Player.isPlayerInFleetsWithPlayer liefert falsches Ergebnis ###")
        
    }

    func testIsPlayerInFleetMovementWithPlayer() {
        //TODO: niklas
        
    }

    func testIsPlayOnPlanetWithPlayer() {
        //TODO: niklas

    }
    
    func testIsPlanetOutPutForPlayer() {
        //TODO: niklas

    }

}