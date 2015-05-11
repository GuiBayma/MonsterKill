//
//  HighScoreScene.swift
//  Monster Kill
//
//  Created by Guilherme Bayma on 5/7/15.
//  Copyright (c) 2015 Guilherme Bayma. All rights reserved.
//

import Foundation
import SpriteKit

class HighScoreScene: SKScene {
    
    var backButton: SKNode! = nil
    
    override func didMoveToView(view: SKView) {
        
        backgroundColor = SKColor.whiteColor()
        
        let background = SKSpriteNode(imageNamed: "highBackground")
        background.alpha = 0.6
        background.anchorPoint = CGPointMake(0.5, 0.5)
        background.size.height = self.size.height
        background.size.width = self.size.width
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
        self.addChild(background)
        
        let titlelabel = SKLabelNode(fontNamed: "Chalkduster")
        titlelabel.text = "High Scores"
        titlelabel.fontSize = 50
        titlelabel.fontColor = SKColor.blackColor()
        titlelabel.position = CGPoint(x: size.width/2, y: size.height*0.85)
        addChild(titlelabel)
        
        var userScoreArray = [0,0,0]
        let defaults = NSUserDefaults.standardUserDefaults()
        if let array = defaults.arrayForKey("userScoreArray") as? [(Int)] {
            userScoreArray = array
        }
        
        let bestScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        bestScoreLabel.text = "1st:   \(userScoreArray[0])"
        bestScoreLabel.fontSize = 20
        bestScoreLabel.fontColor = SKColor.blackColor()
        bestScoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.7)
        addChild(bestScoreLabel)
        
        let secondScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        if userScoreArray.count > 1 {
            secondScoreLabel.text = "2nd:   \(userScoreArray[1])"
        } else {
            secondScoreLabel.text = "2nd:   0"
        }
        secondScoreLabel.fontSize = 20
        secondScoreLabel.fontColor = SKColor.blackColor()
        secondScoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.6)
        addChild(secondScoreLabel)
        
        let thirdScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        if userScoreArray.count > 2 {
            thirdScoreLabel.text = "3rd:   \(userScoreArray[2])"
        } else {
            thirdScoreLabel.text = "3rd:   0"
        }
        thirdScoreLabel.fontSize = 20
        thirdScoreLabel.fontColor = SKColor.blackColor()
        thirdScoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.5)
        addChild(thirdScoreLabel)
        
        let fourthScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        if userScoreArray.count > 3 {
            fourthScoreLabel.text = "4th:   \(userScoreArray[3])"
        } else {
            fourthScoreLabel.text = "4th:   0"
        }
        fourthScoreLabel.fontSize = 20
        fourthScoreLabel.fontColor = SKColor.blackColor()
        fourthScoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.4)
        addChild(fourthScoreLabel)
        
        let fifthScoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        if userScoreArray.count > 3 {
            fifthScoreLabel.text = "5th:   \(userScoreArray[4])"
        } else {
            fifthScoreLabel.text = "5th:   0"
        }
        fifthScoreLabel.fontSize = 20
        fifthScoreLabel.fontColor = SKColor.blackColor()
        fifthScoreLabel.position = CGPoint(x: size.width/2, y: size.height*0.3)
        addChild(fifthScoreLabel)
        
        
        backButton = SKSpriteNode(imageNamed: "back")
        backButton.position = CGPoint(x: size.width/2, y: size.height*0.15);
        self.addChild(backButton)
        
    }
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        let touch = touches.first as! UITouch
        let touchLocation = touch.locationInNode(self)
        
        if backButton.containsPoint(touchLocation) {
            let reveal = SKTransition.flipHorizontalWithDuration(0.5)
            let initialScene = InitialScene(size: self.size)
            self.view?.presentScene(initialScene, transition: reveal)
        }
        
    }
    
}
