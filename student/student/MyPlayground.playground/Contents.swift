//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"
var index = str.startIndex.advancedBy(str.characters.count-2)
var sub = str.substringToIndex(index)