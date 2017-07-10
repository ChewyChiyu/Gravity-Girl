//
//  GameScene.swift
//  Andrew The Game
//
//  Created by Evan Chen on 7/7/17.
//  Copyright © 2017 Evan Chen. All rights reserved.
//

import SpriteKit
import GameplayKit

enum girlActions{
    case RUN, JUMP, IDLE
}
enum girlDirection{
    case BOTTOM, TOP, LEFT, RIGHT
}
enum gameState{
    case isLaunched, isPlaying, isEnd
}
class GameScene: SKScene , SKPhysicsContactDelegate{
    //MARK: GLOCAL VARS
    
    //GLOBAL ACTIONS
    
    
    //level up boolean
    var levelUp:Bool = true
    
    let runBottomAction = (SKAction.repeatForever(SKAction.move(by: CGVector(dx: 100, dy: 0), duration: 0.5)))
    
    let runRightAction = (SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: 100), duration: 0.5)))
    
    let runTopAction = (SKAction.repeatForever(SKAction.move(by: CGVector(dx: -100, dy: 0), duration: 0.5)))
    
    let runLeftAction = (SKAction.repeatForever(SKAction.move(by: CGVector(dx: 0, dy: -100), duration: 0.5)))
    
    //our MC
    var girl : SKSpriteNode!
    //our other mc
    var mamaBear: SKSpriteNode!
    var bearSize: CGSize!
    var scoreLabel: SKLabelNode!
    var score = 0{
        didSet{
            scoreLabel.text = String(score)
        }
    }
    var jumpControl: Timer!
    
    //MARK: Level state
    
    var level = 0{
        didSet{
            //can level up again
            levelUp = true
            switch(level){
            case 2:
                //spawing in and moving one enemy
                let enemy = Enemy()
                enemy.position = CGPoint(x: 320*0.4,y: -568*0.4)
                enemy.run(SKAction.repeatForever(SKAction.sequence([                SKAction.wait(forDuration: 2)
                    ,SKAction.moveBy(x: -320*0.35, y: 0, duration: 2),SKAction.moveBy(x: 320*0.35, y: 0, duration: 2)])))
                self.addChild(enemy)
                
                break
            case 4:
                let enemy = Enemy()
                enemy.zRotation = CGFloat(Double.pi)
                enemy.position = CGPoint(x: -320*0.4,y: 568*0.4)
                enemy.run(SKAction.repeatForever(SKAction.sequence([                SKAction.wait(forDuration: 2)
                    ,SKAction.moveBy(x: 320*0.35, y: 0, duration: 2),SKAction.moveBy(x: -320*0.35, y: 0, duration: 2)])))
                self.addChild(enemy)
                break
            case 6:
                let enemy = Enemy()
                enemy.position = CGPoint(x:0, y: mamaBear.size.height/2)
                enemy.run(SKAction.repeatForever(SKAction.sequence([                SKAction.wait(forDuration: 1)
                    ,SKAction.moveBy(x: 0, y: 320*0.1, duration: 2),SKAction.moveBy(x: 0, y: -320*0.1, duration: 1)])))
                self.addChild(enemy)
                break
            case 8:
                let enemy = Enemy()
                enemy.position = CGPoint(x: -320*0.4,y: -568*0.4)
                enemy.run(SKAction.repeatForever(SKAction.sequence([                SKAction.wait(forDuration: 2)
                    ,SKAction.moveBy(x: 320*0.35, y: 0, duration: 2),SKAction.moveBy(x: -320*0.35, y: 0, duration: 2)])))
                self.addChild(enemy)
                break
            case 10:
                let enemy = Enemy()
                enemy.zRotation = CGFloat(Double.pi)
                enemy.position = CGPoint(x: 320*0.4,y: 568*0.4)
                enemy.run(SKAction.repeatForever(SKAction.sequence([                SKAction.wait(forDuration: 2)
                    ,SKAction.moveBy(x: -320*0.35, y: 0, duration: 2),SKAction.moveBy(x: 320*0.35, y: 0, duration: 2)])))
                self.addChild(enemy)
                break
            case 12:
                let enemy = Enemy()
                enemy.zRotation = CGFloat(Double.pi)
                enemy.position = CGPoint(x:0, y: -mamaBear.size.height/2)
                enemy.run(SKAction.repeatForever(SKAction.sequence([                SKAction.wait(forDuration: 1)
                    ,SKAction.moveBy(x: 0, y: -320*0.1, duration: 2),SKAction.moveBy(x: 0, y: 320*0.1, duration: 1)])))
                self.addChild(enemy)
                break
            default:
                break
            }
        }
    }
    
    
    //GLOBAL STATE FUNCTIONS
    
    var girlState: girlActions = .RUN{
        didSet{
            switch(girlState){
            case .IDLE:
                girl.run(SKAction.repeatForever(SKAction(named: "Idle")!), withKey: "Idle")
                break
            case .RUN:
                //stop all previous actions
                girl.removeAction(forKey: "Idle")
                girl.removeAction(forKey: "Jump")
                girl.run(SKAction.repeatForever(SKAction(named: "Run")!), withKey: "Run")
                break
            case .JUMP:
                girl.removeAction(forKey: "Run")
                girl.run(SKAction(named: "Jump")!, completion: {
                    DispatchQueue.main.async {
                        self.girlState = .RUN
                    }
                })
                break
            }
        }
    }
    var directionGirl: girlDirection = .BOTTOM{
        didSet{
            switch(directionGirl){
            case .BOTTOM:
                self.girl.removeAction(forKey: "runLeft")
                self.girl.removeAction(forKey: "runTop")
                
                self.girl.run(runBottomAction, withKey: "runBottom")
                break
            case .LEFT:
                self.girl.removeAction(forKey: "runTop")
                self.girl.removeAction(forKey: "runRight")
                self.girl.run(runLeftAction, withKey: "runLeft")
                break
            case .RIGHT:
                self.girl.removeAction(forKey: "runBottom")
                self.girl.removeAction(forKey: "runLeft")
                self.girl.run(runRightAction, withKey: "runRight")
                break
            case .TOP:
                self.girl.removeAction(forKey: "runRight")
                self.girl.removeAction(forKey: "runBottom")
                self.girl.run(runTopAction, withKey: "runTop")
                break
            }
        }
    }
    var state : gameState = .isLaunched{
        didSet{
            switch(state){
            case .isLaunched:
                //starting up girl
                directionGirl = .BOTTOM
                DispatchQueue.main.async {
                    //Setting play state to is playing
                    self.state = .isPlaying
                }
                break
            case .isPlaying:
                //staring up run
                girlState = .RUN
                //Starting the timer
                DispatchQueue.main.async {
                    self.jumpControl = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.manageJumps), userInfo: nil, repeats: true)
                }
                //start spawning candy
                
                let spawnCandyAction = SKAction.run {
                    //switching arc random for a random piece of candy
                    let candy = Candy()
                    //adding candy to screen
                    self.addChild(candy)
                    
                    
                }
                run(SKAction.repeatForever(SKAction.sequence([SKAction.wait(forDuration: 1),spawnCandyAction])), withKey: "spawnCandy")
                
                
                break
            case .isEnd:
                print("ending game")
                //removing spawn candy action
                self.removeAction(forKey: "spawnCandy")
                jumpControl.invalidate()
                
                //small wait time
                run(SKAction.wait(forDuration: 1), completion: {
                    
                    
                    //sending score to view controller
                    GameViewController.score = self.score
                    //loading in end scene
                    if let scene = SKScene(fileNamed:"EndScene.sks") {
                        let skView = self.view! as SKView
                        
                        skView.ignoresSiblingOrder = true
                        
                        scene.size = skView.bounds.size
                        scene.scaleMode = .aspectFill
                        
                        
                        
                        skView.presentScene(scene, transition: SKTransition.fade(withDuration: 2))
                    }
                })
                
            }
        }
    }
    //managing jumps of girl
    func manageJumps(){
        //regular corner rotation
        if(girl.position.x > (320 * 0.2)){
            if(directionGirl == .BOTTOM){
                //switch directions
                self.physicsWorld.gravity = CGVector(dx: 9.8, dy: 0)
                girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 0.2))
                directionGirl = .RIGHT
            }
        }
        if(girl.position.y > (568 * 0.3)){
            if(directionGirl == .RIGHT){
                //switch directions
                self.physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
                girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 0.2))
                directionGirl = .TOP
            }
        }
        if(girl.position.x < -(320*0.2)){
            if(directionGirl == .TOP){
                //switch directions
                self.physicsWorld.gravity = CGVector(dx: -9.8, dy: 0)
                girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 0.2))
                directionGirl = .LEFT
            }
        }
        if(girl.position.y < -(568*0.3)){
            if(directionGirl == .LEFT){
                //switch directions
                self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
                girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 0.2))
                directionGirl = .BOTTOM
            }
        }
        
        //cross wall jumping
        if(girl.position.y > 0 && directionGirl == .BOTTOM){
            //switch directions
            self.physicsWorld.gravity = CGVector(dx: 0, dy: 9.8)
            girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.2))
            directionGirl = .TOP
        }
        if(girl.position.y < 0 && directionGirl == .TOP){
            self.physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
            girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.2))
            directionGirl = .BOTTOM
        }
        if(girl.position.x > 0 && directionGirl == .LEFT){
            self.physicsWorld.gravity = CGVector(dx: 9.8, dy: 0)
            girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.2))
            directionGirl = .RIGHT
        }
        if(girl.position.x < 0 && directionGirl == .RIGHT){
            self.physicsWorld.gravity = CGVector(dx: -9.8, dy: 0)
            girl.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.2))
            directionGirl = .LEFT
        }
    }
    
    
    
    override func didMove(to view: SKView) {
        
        //starting up vars from sks file
        girl = self.childNode(withName: "Girl") as? SKSpriteNode
        //heavy girl
        girl.physicsBody?.mass = 1
        mamaBear = self.childNode(withName: "MamaBear") as? SKSpriteNode
        bearSize = mamaBear.size
        scoreLabel = mamaBear.childNode(withName: "Score") as! SKLabelNode
        
        
        girlState = .IDLE  //default girl values
        
        //setting contact delegate to self
        self.physicsWorld.contactDelegate = self
        
    }
    
    
    //MARK : handling physics contact
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        //if girl touches candy bear eats it and gets bigger
        
        let contactA = contact.bodyA
        let contactB = contact.bodyB
        
        if(contactA.node?.name == "Girl" && contactB.node?.name == "candy"){
            let candy = contactB.node as? Candy
            if(!(candy?.isEaten)!){
                candy?.isEaten = true
                //continue with action
                candy?.physicsBody?.collisionBitMask = 0
                candy?.run(SKAction.move(to: mamaBear.position, duration: 0.3), completion:{
                    self.mamaBear.run(SKAction.scale(by: 1.2, duration: 1))
                    candy?.removeFromParent()
                    self.score+=1
                })
            }
            
        }
        if(contactB.node?.name == "Girl" && contactA.node?.name == "candy"){
            let candy = contactA.node as? Candy
            if(!(candy?.isEaten)!){
                candy?.isEaten = true
                //continue with action
                candy?.physicsBody?.collisionBitMask = 0
                candy?.run(SKAction.move(to: mamaBear.position, duration: 0.3), completion:{
                    self.mamaBear.run(SKAction.scale(by: 1.2, duration: 1))
                    candy?.removeFromParent()
                    self.score+=1
                })
            }
            
        }
        
        if(contactA.node?.name == "Girl" && contactB.node?.name == "enemy"){
            //death
            let enemy = contactB.node as? Enemy
            if(!(enemy?.hit)!){
                enemy?.hit = true
                contactA.node?.removeAllActions()
                contactA.node?.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1))
                contactA.node?.physicsBody?.collisionBitMask = 0
                state = .isEnd
            }
        }
        if(contactB.node?.name == "Girl" && contactA.node?.name == "enemy"){
            //death
            let enemy = contactA.node as? Enemy
            if(!(enemy?.hit)!){
                enemy?.hit = true
                contactB.node?.removeAllActions()
                contactB.node?.run(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1))
                contactB.node?.physicsBody?.collisionBitMask = 0
                state = .isEnd
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        
        //set game state to isLaunch, starting up girl
        if(state == .isLaunched){
            //removing tap to start label
            let startLabel = self.childNode(withName: "StartLabel") as? SKLabelNode
            startLabel?.removeFromParent()
            state = .isLaunched
        }
        //getting vector of jump based on location
        if(state == .isPlaying){
            var jumpVector = CGVector.zero
            switch(directionGirl){
            case .BOTTOM:
                jumpVector = CGVector(dx: 50, dy: 380)
                break
            case .TOP:
                jumpVector = CGVector(dx: -50, dy: -380)
                break
            case .RIGHT:
                jumpVector = CGVector(dx: -380, dy: 50)
                break
            case .LEFT:
                jumpVector = CGVector(dx: 380, dy: -50)
                break
            }
            girl.physicsBody?.applyImpulse(jumpVector)
            //setting girl state to jump for animation
            girlState = .JUMP
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        //handling removal of candy
        
        for child in self.children{
            if(child.name == "candy" && !intersects(child)){
                child.removeFromParent()
            }
            if(child.name == "Girl" && !intersects(child) && state == .isPlaying){
                state = .isEnd
            }
        }
        if(mamaBear.size.width > 150 && levelUp){
            levelUp = false
            //prevents level from increasing more than once
            mamaBear.run(SKAction.scale(to: bearSize, duration: 0.5))
            mamaBear.run(SKAction.rotate(byAngle: CGFloat(Double.pi/2), duration: 1), completion: {
                self.level+=1
            })
        }
    }
}
