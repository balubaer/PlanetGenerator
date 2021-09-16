//
//  Port.swift
//  PlanetGenerator
//
//  Created by Bernd Niklas on 05.10.14.
//  Copyright (c) 2014 Bernd Niklas. All rights reserved.
//

import Foundation

class Port {
    var planets:Array <Planet>
    var planet:Planet?
    
    init() {
        planets = Array()
    }
    
    var description: String {
        var desc = ""
        let connectionCount = planets.count
        if planet != nil {
            desc = planet!.name
        }  else {
            desc = "W?"
        }
        if (connectionCount > 0) {
            var counter = 0
            desc += "("
            planets.sort { $0 < $1 }
            for item in planets {
                let number = item.number
                desc += "\(number)"
                if counter < (connectionCount - 1) {
                    desc += ","
                }
                counter += 1;
            }
            desc += ")"
        }
        return desc
    }
    
    func hasConnectionToPlanet(_ aPlant : Planet) -> Bool {
        return planets.contains(aPlant)
    }
    
    func addXMLConnectOnParent(_ parent : XMLElement) {
        for planet in planets {
            let childElementConnect = XMLElement(name: "connect")
            if let attribute = XMLNode.attribute(withName: "index", stringValue: "\(planet.number)") as? XMLNode {
                childElementConnect.addAttribute(attribute)
                parent.addChild(childElementConnect)
            }
        }
    }
    
}
