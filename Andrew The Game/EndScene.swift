//
//  EndScene.swift
//  Andrew The Game
//
//  Created by Evan Chen on 7/8/17.
//  Copyright © 2017 Evan Chen. All rights reserved.
//

import Foundation
import SpriteKit
import GoogleMobileAds
import UIKit

class EndScene: SKScene{
    
    //ad var
    var interstitial: GADInterstitial!
    
    override func didMove(to view: SKView) {
        
        
        //handle button
        let resetButton = self.childNode(withName: "RestartButton") as? Button
        
        resetButton?.playAction = {
            
            //loading in Game scene
            if let scene = SKScene(fileNamed:"GameScene.sks") {
                let skView = self.view! as SKView
                
                skView.ignoresSiblingOrder = true
                scene.size = skView.bounds.size
                scene.scaleMode = .aspectFill
                
                skView.presentScene(scene, transition: SKTransition.fade(withDuration: 2))
            }

        }
        
        
        //applying scores and such
        
        let scoreLabel = self.childNode(withName: "Score") as? SKLabelNode
        let bearScoreLabel = self.childNode(withName: "BearScore") as? SKLabelNode
        let highScoreLabel = self.childNode(withName: "Highscore") as? SKLabelNode

        let score = GameViewController.score
        
        scoreLabel?.text = String(score)
        bearScoreLabel?.text = String(score)
        
        
        //highscore config retreive from user defaults and compare / assign
        //manage highscores
        if let s = UserDefaults.standard.value(forKey: "highscore") {
            if(score > (s as? Int)!){
                UserDefaults.standard.set(score, forKey: "highscore")
            }
        } else {
            //user default does not exist yet so set highscore to current rounds score
            UserDefaults.standard.set(score, forKey: "highscore")
            
        }
        //get highscore again and place on highscore label
        let highscore = (UserDefaults.standard.value(forKey: "highscore") as? Int)!
        highScoreLabel?.text = String(highscore)
        
        
        
        
        //handle ads here
        //setting up ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-1967902439424087/2209611050")
        let request = GADRequest()
        
        interstitial.load(request)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if self.interstitial.isReady {
                print("showing add")
                self.interstitial.present(fromRootViewController: (self.view?.window!.rootViewController)!)
            }else{
                print("no ad to show")
            }
        }

        

        
        
        
    }
    
}
