//
//  GameScene.swift
//  OnePunchKing
//
//  Created by Jerry Shi on 1/14/16.
//  Copyright (c) 2016 jerryszp. All rights reserved.
//

import SpriteKit
import CoreMotion
import UIKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    var movingObjects = SKSpriteNode()
    
    var OnePunch = SKSpriteNode()
    var leftBoarder = SKSpriteNode()
    var rightBoarder = SKSpriteNode()
    var motionManager = CMMotionManager()
    var destX:CGFloat  = 0.0
    var bg = SKSpriteNode()
    
    var hardkings:[NaiveKings] = []
    var endOfScreenRight = CGFloat()
    var endOfScreenLeft = CGFloat()
    var gameOver = false
    
    enum ColliderType:UInt32{
        case onePunch = 1
        case hardkings = 2
        case leftBoarder = 4
        case rightBoarder = 8
        
    }
    
    
    func addBg() {
        let bgTexture = SKTexture(imageNamed: "bg.png")
        bg = SKSpriteNode(texture: bgTexture)
        //bg.position = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        bg.position = CGPoint(x: 0, y: 0)
        bg.size = self.frame.size
        addChild(bg)
    }
    
    //Code for onepunch
    func addOnePunch() {
        
        OnePunch = SKSpriteNode(imageNamed: "onePunchMain.png")
        
        OnePunch.physicsBody = SKPhysicsBody(rectangleOf: OnePunch.size)
        OnePunch.physicsBody!.affectedByGravity = false
        OnePunch.physicsBody!.allowsRotation = false
        
        OnePunch.physicsBody!.categoryBitMask = ColliderType.onePunch.rawValue
        OnePunch.physicsBody!.contactTestBitMask = ColliderType.hardkings.rawValue
        OnePunch.physicsBody!.collisionBitMask = ColliderType.hardkings.rawValue
        
        OnePunch.physicsBody!.contactTestBitMask = ColliderType.leftBoarder.rawValue
        OnePunch.physicsBody!.collisionBitMask = ColliderType.leftBoarder.rawValue
        OnePunch.physicsBody!.contactTestBitMask = ColliderType.rightBoarder.rawValue
        OnePunch.physicsBody!.collisionBitMask = ColliderType.rightBoarder.rawValue
        
        OnePunch.position = CGPoint(x: 0, y: -(frame.size.height/2.5))
        self.addChild(OnePunch)
        
        if motionManager.isAccelerometerAvailable == true {
            motionManager.startAccelerometerUpdates(to: OperationQueue.current!, withHandler:{
                data, error in
                
                var currentX = self.OnePunch.position.x
                
                // 3
                if data!.acceleration.x < 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 888)
                }
                else if data!.acceleration.x > 0 {
                    self.destX = currentX + CGFloat(data!.acceleration.x * 888)
                }
            })
        }
    }
    
    func addLeftBoarder(){
        leftBoarder.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        leftBoarder.physicsBody!.affectedByGravity = false
        leftBoarder.physicsBody!.allowsRotation = false
        leftBoarder.physicsBody!.velocity = CGVector(dx: 0,dy: 0)
        
        leftBoarder.physicsBody!.categoryBitMask = ColliderType.leftBoarder.rawValue
        leftBoarder.physicsBody!.contactTestBitMask = ColliderType.onePunch.rawValue
        leftBoarder.physicsBody!.collisionBitMask = ColliderType.onePunch.rawValue
        
        leftBoarder.position = CGPoint(x: -self.frame.width*1.5, y: self.frame.height/2)
        self.addChild(leftBoarder)
        
    }
    func addRightBoarder(){
        rightBoarder.physicsBody = SKPhysicsBody(rectangleOf: self.frame.size)
        rightBoarder.physicsBody!.affectedByGravity = false
        rightBoarder.physicsBody!.allowsRotation = false
        rightBoarder.physicsBody!.velocity = CGVector(dx: 0,dy: 0)
        
        rightBoarder.physicsBody!.categoryBitMask = ColliderType.leftBoarder.rawValue
        rightBoarder.physicsBody!.contactTestBitMask = ColliderType.onePunch.rawValue
        rightBoarder.physicsBody!.collisionBitMask = ColliderType.onePunch.rawValue
        
        rightBoarder.position = CGPoint(x: (frame.size.width)*1.5, y: frame.size.height)
        self.addChild(rightBoarder)
        
    }

    
    //add more hardkings
    func addHardKings() {
        addoneHardKing(named: "HardKing1", speed: 0.8, xPos: CGFloat(self.size.width/8))
        addoneHardKing(named: "HardKing2", speed: 1.2, xPos: CGFloat(self.size.width/4))
        addoneHardKing(named: "HardKing3", speed: 1.6, xPos: CGFloat(-(self.size.width/3)))
        addoneHardKing(named: "HardKing4", speed: 2.0, xPos: CGFloat(-(self.size.width/6)))
    }
    
    
    //add one hardking
    func addoneHardKing(named:String, speed:Float, xPos:CGFloat){
        
        var hardkingNode = SKSpriteNode(imageNamed: named)
        
        hardkingNode.physicsBody = SKPhysicsBody(rectangleOf: hardkingNode.size)
        hardkingNode.physicsBody!.affectedByGravity = false
        hardkingNode.physicsBody!.allowsRotation = false
        
        hardkingNode.physicsBody!.categoryBitMask = ColliderType.hardkings.rawValue
        hardkingNode.physicsBody!.contactTestBitMask = ColliderType.onePunch.rawValue
        hardkingNode.physicsBody!.collisionBitMask = ColliderType.onePunch.rawValue
        
        var hardking = NaiveKings(speed: speed,guy: hardkingNode)
        
        hardkings.append(hardking)
        
        resetHardking(hardkingNode, xPos: xPos)
        
        hardking.xPos = hardkingNode.position.x
        
        addChild(hardkingNode)
        
    }
    
    func resetHardking(_ hardkingNode:SKSpriteNode, xPos: CGFloat) {
        
        hardkingNode.position.y = endOfScreenRight
        hardkingNode.position.x = xPos
        
    }
    
    func updateHardkingsPosition() {
        
        for hardking in hardkings {
            
            if !hardking.moving {
                
                hardking.currentFrame++
                
                if hardking.currentFrame > hardking.randomFrame{
                    
                    hardking.moving = true
                    
                }
                
            }else{
                
                hardking.guy.position.x = CGFloat(Double(hardking.guy.position.x) + sin(hardking.angle) * hardking.range)
                hardking.angle += 0.1
                
                if hardking.guy.position.y > endOfScreenLeft {
                    
                    hardking.guy.position.y -= CGFloat(hardking.speed)
                    
                }else{
                    
                    hardking.guy.position.y = endOfScreenRight
                    hardking.currentFrame = 0
                    hardking.setRandomFrame()
                    hardking.moving = false
                    hardking.range += 0.1
                    updateScore()
                    
                    
                    
                }
                
            }
            
        }
        
    }
    
    func updateScore() {
        
        
    }
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        
        self.physicsWorld.contactDelegate = self
        
        endOfScreenLeft = (self.size.height / 2) * CGFloat(-1)
        
        endOfScreenRight = (self.size.height / 2)
        
        addBg()
        
        addOnePunch()
        
        addHardKings()
        
        addLeftBoarder()
        
        addRightBoarder()
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        gameOver = false
        
        print("A Hit~!!!")
        
    }
    
    
    //Create an object oh the same level as the onepunch then apply physics world ...
    //
    
    
   
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        var action = SKAction.moveTo(x: destX, duration: 1)
        self.OnePunch.run(action)
        
        if !gameOver {
            
            updateHardkingsPosition()
            
        }
        
    }
}
