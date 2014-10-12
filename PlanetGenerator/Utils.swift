//
//  Utils.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 12.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

func createBracketAndCommarStringWithStringArray(aStringArray:Array <String>) -> String {
    var result = "("
    var counter = 0
    var maxCounter = aStringArray.count - 1
    
    for string in aStringArray {
        result += string
        if counter < maxCounter {
            result += ","
        }
        counter++
    }
    result += ")"

    return result
}