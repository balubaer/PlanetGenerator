//
//  FleetFactory.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class FleetFactory {
    var dice: Dice
    var fleetCount: Int
    
    init(aFleetCount: Int) {
        dice = Dice()
        fleetCount = aFleetCount
    }
    
    func createWithPlanetArray(planetArray:Array <Planet>) {
        dice.setSites(planetArray.count)

        //Create Fleets
        for index in 1...fleetCount {
            let planet: Planet? = planetWithNumber(planetArray, number: dice.roll())
            
            if planet != nil {
                let fleet = Fleet()
                fleet.number = index
                planet!.fleets.append(fleet)
            }
        }
    }
}