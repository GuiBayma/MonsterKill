//
//  GameOverScene.swift
//  Monster Kill
//
//  Created by Guilherme Bayma on 5/7/15.
//  Copyright (c) 2015 Guilherme Bayma. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    init(size: CGSize, monsters: Int) {
        
        super.init(size: size)
        
        backgroundColor = SKColor.whiteColor()
        
        let background = SKSpriteNode(imageNamed: "initBackground")
        background.alpha = 0.6
        background.anchorPoint = CGPointMake(0.5, 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(background)
        
        var message = "Game Over!"
        var scoreArray: [(Int)]!
        
        // 3
        let label = SKLabelNode(fontNamed: "Chalkduster")
        label.text = message
        label.fontSize = 40
        label.fontColor = SKColor.blackColor()
        label.position = CGPoint(x: size.width/2, y: size.height*0.7)
        addChild(label)
        
        let score1 = SKLabelNode(fontNamed: "Chalkduster")
        score1.text = "You killed"
        score1.fontSize = 40
        score1.fontColor = SKColor.blackColor()
        score1.position = CGPoint(x: size.width/2, y: size.height*0.45)
        addChild(score1)
        
        let score2 = SKLabelNode(fontNamed: "Chalkduster")
        score2.text = "\(monsters)"
        score2.fontSize = 40
        score2.fontColor = SKColor.blackColor()
        score2.position = CGPoint(x: size.width/2, y: size.height*0.35)
        addChild(score2)
        
        let score3 = SKLabelNode(fontNamed: "Chalkduster")
        score3.text = "monsters!"
        score3.fontSize = 40
        score3.fontColor = SKColor.blackColor()
        score3.position = CGPoint(x: size.width/2, y: size.height*0.25)
        addChild(score3)
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if let array = defaults.arrayForKey("userScoreArray") {
            scoreArray = array as! [(Int)]
        } else {
            scoreArray = [(Int)]()
        }
        scoreArray.append(monsters)
        let sortedArray = scoreArray.sorted {$0 > $1}
        defaults.setObject(sortedArray, forKey: "userScoreArray")
        
        
        // 4
        runAction(SKAction.sequence([
            SKAction.waitForDuration(3.0),
            SKAction.runBlock() {
                // 5
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let scene = InitialScene(size: size)
                self.view?.presentScene(scene, transition:reveal)
            }
            ]))
        
    }
    
    // 6
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
