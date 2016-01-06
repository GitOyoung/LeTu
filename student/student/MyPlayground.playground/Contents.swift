//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class User:NSObject{
    var name:String = "张三"
    var pwd:String = "123456"
}
class Mod:NSObject{
    var user:User = User()
}

var mod:Mod = Mod()
print(NSDictionary().description)
