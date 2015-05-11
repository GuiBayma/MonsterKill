//
//  InitialScene.swift
//  Monster Kill
//
//  Created by Guilherme Bayma on 5/7/15.
//  Copyright (c) 2015 Guilherme Bayma. All rights reserved.
//

import Foundation
import SpriteKit

class InitialScene: SKScene {
    
    var highScoreButton: SKNode! = nil
    var playButton: SKNode! = nil
    var ninjaButton: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        playBackgroundMusic("background-music-aac.caf")
        // 2
        backgroundColor = SKColor.whiteColor()
        //self.alpha = 0.8
        
        let background = SKSpriteNode(imageNamed: "initBackground")
        background.alpha = 0.6
        background.anchorPoint = CGPointMake(0.5, 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(background)
        
        let titlelabel1 = SKLabelNode(fontNamed: "Chalkduster")
        titlelabel1.text = "Ninja"
        titlelabel1.fontSize = 60
        titlelabel1.fontColor = SKColor.blackColor()
        titlelabel1.position = CGPoint(x: size.width/2, y: size.height*0.85)
        addChild(titlelabel1)
        
        let titlelabel2 = SKLabelNode(fontNamed: "Chalkduster")
        titlelabel2.text = "Monster"
        titlelabel2.fontSize = 60
        titlelabel2.fontColor = SKColor.blackColor()
        titlelabel2.position = CGPoint(x: size.width/2, y: size.height*0.75)
        addChild(titlelabel2)
        
        let titlelabel3 = SKLabelNode(fontNamed: "Chalkduster")
        titlelabel3.text = "Kill"
        titlelabel3.fontSize = 60
        titlelabel3.fontColor = SKColor.blackColor()
        titlelabel3.position = CGPoint(x: size.width/2, y: size.height*0.65)
        addChild(titlelabel3)
        
        let ghost = SKSpriteNode(imageNamed: "monster")
        ghost.alpha = 0.6
        ghost.position = CGPoint(x: size.width * 0.2, y: size.height * 0.32)
        addChild(ghost)
        
        ninjaButton = SKSpriteNode(imageNamed: "player")
        ninjaButton.alpha = 0.6
        ninjaButton.position = CGPoint(x: size.width * 0.75, y: size.height * 0.5)
        addChild(ninjaButton)
        
        playButton = SKSpriteNode(imageNamed: "play")
        playButton.position = CGPoint(x: size.width/2, y: size.height*0.4);
        self.addChild(playButton)
        
        highScoreButton = SKSpriteNode(imageNamed: "high")
        highScoreButton.position = CGPoint(x: size.width/2, y: size.height*0.2)
        self.addChild(highScoreButton)
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        
        if playButton.containsPoint(touchLocation) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let gameScene = GameScene(size: self.size)
            self.view?.presentScene(gameScene, transition: reveal)
        }
        else if highScoreButton.containsPoint(touchLocation) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let highScoreScene = HighScoreScene(size: self.size)
            self.view?.presentScene(highScoreScene, transition: reveal)
        }
        else if ninjaButton.containsPoint(touchLocation) {
            runAction(SKAction.playSoundFileNamed("pew-pew-lei.caf", waitForCompletion: false))
        }
    }
    
}
