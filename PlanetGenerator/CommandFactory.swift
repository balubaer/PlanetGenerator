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
    var fleets: Array <Fleet>
    
    init(aPlanetArray: Array <Planet>, aFleetArray: Array <Fleet>) {
        planets = aPlanetArray
        fleets = aFleetArray
    }
}

/*
var myString = "One-Two-Three-1 2 3"
var array : String[] = myString.componentsSeparatedByCharactersInSet(NSCharacterSet (charactersInString: "- "))
//Returns ["One", "Two", "Three", "1", "2", "3"]
*/