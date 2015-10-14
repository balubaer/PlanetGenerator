// Playground - noun: a place where people can play

import Cocoa

var str = "Hello, playground"

let range = str.startIndex...str.startIndex.successor()
str.removeRange(range)
