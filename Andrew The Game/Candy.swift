//
//  Candy.swift
//  Andrew The Game
//
//  Created by Evan Chen on 7/8/17.
//  Copyright © 2017 Evan Chen. All rights reserved.
//

import Foundation
import SpriteKit


class Candy: SKSpriteNode{
    
    var isEaten: Bool = false
    
    init(){
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: 0, height: 0))

        switch(arc4random_uniform(7)){
            
            
        case 0:
            self.texture = SKTexture(imageNamed: "wrappedsolid_red")
            break
        case 1:
             self.texture = SKTexture(imageNamed: "wrappedsolid_blue")
            break
        case 2:
             self.texture = SKTexture(imageNamed: "wrappedsolid_green")
            break
        case 3:
             self.texture = SKTexture(imageNamed: "wrappedsolid_orange")
            break
        case 4:
             self.texture = SKTexture(imageNamed: "wrappedsolid_purple")
            break
        case 5:
             self.texture = SKTexture(imageNamed: "wrappedsolid_teal")
            break
        case 6:
             self.texture = SKTexture(imageNamed: "wrappedsolid_yellow")
            break
        default:
            break
        }
        //applying size
        self.size = (texture?.size())!
        
        //applying physics to candy
        self.physicsBody = SKPhysicsBody(texture: self.texture!, size: self.size)
        
        
        //adding name to candy
        self.name = "candy"
        
        //adding candy to random location
        self.position = CGPoint.zero
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
