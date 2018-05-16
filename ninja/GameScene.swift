//
//  GameScene.swift
//  ninja
//
//  Created by Tharzeez on 5/16/18.
//  Copyright © 2018 tharzeez. All rights reserved.
//

import SpriteKit
import GameplayKit

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let monster   : UInt32 = 0b1
    static let projectile: UInt32 = 0b10
    static let ninja     : UInt32 = 0b11
}

class GameScene: SKScene {
    
    let player = SKSpriteNode(imageNamed: "player")
    
    override func didMove(to view: SKView) {
        backgroundColor = SKColor.white
        
        player.position = CGPoint(x: size.width * 0.1, y: size.height * 0.5)
        addChild(player)
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        run(SKAction.repeatForever(SKAction.sequence([SKAction.run(addMonster),SKAction.wait(forDuration: 1.0)])))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.physicsBody = SKPhysicsBody(rectangleOf: monster.size)
        monster.physicsBody?.isDynamic = true
        monster.physicsBody?.categoryBitMask = PhysicsCategory.monster
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.ninja
        monster.physicsBody?.collisionBitMask = PhysicsCategory.none
        
        // Determine where to spawn the monster along the Y axis
        let actualY = random(min: monster.size.height/2, max: size.height - monster.size.height/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: size.width + monster.size.width/2, y: actualY)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        let actualDuration = random(min: CGFloat(2.0), max: CGFloat(4.0))
        
        // Create the actions
        let actionMove = SKAction.move(to: CGPoint(x: -monster.size.width/2, y: actualY),
                                       duration: TimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        monster.run(SKAction.sequence([actionMove, actionMoveDone]))
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
}
