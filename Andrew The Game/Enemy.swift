//
//  Enemy.swift
//  Andrew The Game
//
//  Created by Evan Chen on 7/8/17.
//  Copyright © 2017 Evan Chen. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy : SKSpriteNode{
    
    var hit:Bool = false
    
    init(){
        let texture = SKTexture(imageNamed: "Jelly (6)")
        
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.setScale(0.10)
        self.zPosition = 2
        
        //applying physics to enemy
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.collisionBitMask = 0
        
        
        
        self.name = "enemy"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
