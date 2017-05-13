//
//  NaiveKings.swift
//  OnePunchKing
//
//  Created by Jerry Shi on 1/14/16.
//  Copyright © 2016 jerryszp. All rights reserved.
//

import Foundation
import SpriteKit

class NaiveKings {
    
    var speed:Float = 0.0
    
    var guy:SKSpriteNode
    
    var currentFrame = 0
    var randomFrame = 0
    var moving = false
    var angle = 0.0
    var range = 2.0
    var xPos = CGFloat()
    
    init(speed:Float, guy:SKSpriteNode){
        
        self.speed = speed
        self.guy = guy
        self.setRandomFrame()
        
    }
    
    func setRandomFrame() {
        var range = UInt32(50)..<UInt32(200)
        self.randomFrame = Int(range.lowerBound + arc4random_uniform(range.upperBound - range.lowerBound + 1))
        
        
        
        
    }
    
}
