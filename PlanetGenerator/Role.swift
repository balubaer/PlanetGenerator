//
//  Role.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 11.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Role {
    var name: String
    
    var description: String {
        var desc = "Character Name: \(name)"
        return desc
    }
    
    init() {
        name = "NO Name"
    }
    
}
