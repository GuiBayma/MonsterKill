//
//  GameScene.swift
//  Monster Kill
//
//  Created by Guilherme Bayma on 5/7/15.
//  Copyright (c) 2015 Guilherme Bayma. All rights reserved.
//

import SpriteKit
import AVFoundation
import Darwin

var backgroundMusicPlayer: AVAudioPlayer!

func playBackgroundMusic(filename: String) {
    let url = NSBundle.mainBundle().URLForResource(
        filename, withExtension: nil)
    if (url == nil) {
        println("Could not find file: \(filename)")
        return
    }
    
    var error: NSError? = nil
    backgroundMusicPlayer =
        AVAudioPlayer(contentsOfURL: url, error: &error)
    if backgroundMusicPlayer == nil {
        println("Could not create audio player: \(error!)")
        return
    }
    
    backgroundMusicPlayer.numberOfLoops = -1
    backgroundMusicPlayer.prepareToPlay()
    backgroundMusicPlayer.play()
}

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
    return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}

struct PhysicsCategory {
    static let None      : UInt32 = 0
    static let All       : UInt32 = UInt32.max
    static let Monster   : UInt32 = 0b1       // 1
    static let Projectile: UInt32 = 0b10      // 2
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    // 1
    let player = SKSpriteNode(imageNamed: "player")
    var monstersDestroyed = 0
    var titleLabel = SKLabelNode(fontNamed: "Chalkduster")
    var monsterlLabel = SKLabelNode(fontNamed: "Chalkduster")
    var maxSpeedLabel = SKLabelNode(fontNamed: "Chalkduster")
    var monsterSpeed = 3.0
    var numberOfMonsters = 1.0
    var canAddMonster = true
    var canShoot = true
    var numberOfLives = 2
    var livesLabel0 = SKSpriteNode(imageNamed: "player")
    var livesLabel1 = SKSpriteNode(imageNamed: "player")
    
    override func didMoveToView(view: SKView) {
        
        // 2
        backgroundColor = SKColor.whiteColor()
        // 3
        player.position = CGPoint(x: size.width * 0.5, y: size.height * 0.1)
        // 4
        addChild(player)
        
        physicsWorld.gravity = CGVectorMake(0, 0)
        physicsWorld.contactDelegate = self
        
        titleLabel.alpha = 0.6
        titleLabel.text = "Monsters killed: "
        titleLabel.fontSize = 20
        titleLabel.fontColor = SKColor.blackColor()
        titleLabel.position = CGPoint(x: size.width*0.35, y: size.height*0.85)
        addChild(titleLabel)
        
        monsterlLabel.alpha = 0.6
        monsterlLabel.text = "\(monstersDestroyed)"
        monsterlLabel.fontSize = 20
        monsterlLabel.fontColor = SKColor.blackColor()
        monsterlLabel.position = CGPoint(x: size.width*0.75, y: size.height*0.85)
        addChild(monsterlLabel)
        
        maxSpeedLabel.alpha = 0
        maxSpeedLabel.text = "MAX Speed!"
        maxSpeedLabel.fontSize = 15
        maxSpeedLabel.fontColor = SKColor.blackColor()
        maxSpeedLabel.position = CGPoint(x: size.width*0.5, y: size.height*0.8)
        addChild(maxSpeedLabel)
        
        livesLabel0.position = CGPoint(x: size.width*0.86, y: size.height*0.05)
        livesLabel0.alpha = 0.7
        livesLabel0.size.height = player.size.height*3/4
        livesLabel0.size.width = player.size.width*3/4
        addChild(livesLabel0)
        livesLabel1.position = CGPoint(x: size.width*0.9, y: size.height*0.05)
        livesLabel1.alpha = 0.7
        livesLabel1.size.height = player.size.height*3/4
        livesLabel1.size.width = player.size.width*3/4
        addChild(livesLabel1)
        
//        runAction(SKAction.repeatActionForever(
//            SKAction.sequence([
//                SKAction.runBlock(addMonster),
//                SKAction.waitForDuration(self.numberOfMonsters)
//                ])
//            ))
    }
    
    override func update(currentTime: NSTimeInterval) {
        if canAddMonster {
            canAddMonster = false
            runAction(SKAction.runBlock(addMonster))
            delay(self.numberOfMonsters) { self.canAddMonster = true }
        }
    }
    
    func increaseLevel() {
        if self.numberOfMonsters > 0.2 {
            self.numberOfMonsters -= 0.03
        }
        println("\(self.numberOfMonsters)")
        
        if self.monsterSpeed > 0.5 {
            self.monsterSpeed -= 0.1
        } else {
            self.maxSpeedLabel.alpha = 0.8
        }
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(#min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    func addMonster() {
        
        // Create sprite
        let monster = SKSpriteNode(imageNamed: "monster")
        
        monster.physicsBody = SKPhysicsBody(rectangleOfSize: monster.size) // 1
        monster.physicsBody?.dynamic = true // 2
        monster.physicsBody?.categoryBitMask = PhysicsCategory.Monster // 3
        monster.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile // 4
        monster.physicsBody?.collisionBitMask = PhysicsCategory.None // 5
        
        // Determine where to spawn the monster along the Y axis
        let actualX = random(min: monster.size.width/2, max: size.width - monster.size.width/2)
        
        // Position the monster slightly off-screen along the right edge,
        // and along a random position along the Y axis as calculated above
        monster.position = CGPoint(x: actualX, y: size.height + monster.size.height/2)
        
        // Add the monster to the scene
        addChild(monster)
        
        // Determine speed of the monster
        //let actualDuration = random(min: CGFloat(2.0 - self.monsterSpeed), max: CGFloat(4.0 - self.monsterSpeed))
        let actualDuration = self.monsterSpeed
        println("AS: \(actualDuration)")
        
        // Create the actions
        let actionMove = SKAction.moveTo(CGPoint(x: actualX, y: -monster.size.height/2), duration: NSTimeInterval(actualDuration))
        let actionMoveDone = SKAction.removeFromParent()
        let loseAction = SKAction.runBlock() {
            if self.numberOfLives == 0 {
                let reveal = SKTransition.flipHorizontalWithDuration(0.5)
                let gameOverScene = GameOverScene(size: self.size, monsters: self.monstersDestroyed)
                self.view?.presentScene(gameOverScene, transition: reveal)
            } else {
                switch self.numberOfLives {
                case 2:
                    self.livesLabel1.removeFromParent()
                case 1:
                    self.livesLabel0.removeFromParent()
                default: break
                }
                self.numberOfLives--
            }
        }
        monster.runAction(SKAction.sequence([actionMove, loseAction, actionMoveDone]))
        
    }
    
    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        
        if canShoot {
            
            canShoot = false
            
            runAction(SKAction.playSoundFileNamed("woosh_2.mp3", waitForCompletion: false))
            
            // 1 - Choose one of the touches to work with
            let touch = touches.first as! UITouch
            let touchLocation = touch.locationInNode(self)
            
            // 2 - Set up initial location of projectile
            let projectile = SKSpriteNode(imageNamed: "projectile")
            projectile.position = player.position
            
            // 3 - Determine offset of location to projectile
            let offset = touchLocation - projectile.position
            
            // 4 - Bail out if you are shooting down or backwards
            if (offset.y < 0) {
                self.canShoot = true
                return
            }
            
            // 5 - OK to add now - you've double checked position
            addChild(projectile)
            
            // 6 - Get the direction of where to shoot
            let direction = offset.normalized()
            
            // 7 - Make it shoot far enough to be guaranteed off screen
            let shootAmount = direction * 1000
            
            // 8 - Add the shoot amount to the current position
            let realDest = shootAmount + projectile.position
            
            projectile.physicsBody = SKPhysicsBody(circleOfRadius: projectile.size.width/2)
            projectile.physicsBody?.dynamic = true
            projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
            projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Monster
            projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
            projectile.physicsBody?.usesPreciseCollisionDetection = true
            
            // 9 - Create the actions
            let actionMove = SKAction.moveTo(realDest, duration: 2.0)
            let actionMoveDone = SKAction.removeFromParent()
            projectile.runAction(SKAction.sequence([actionMove, actionMoveDone]))
            
            delay(0.1) { self.canShoot = true }
        }
    }
    
    func projectileDidCollideWithMonster(projectile:SKSpriteNode, monster:SKSpriteNode) {
        projectile.removeFromParent()
        monster.removeFromParent()
        
        monstersDestroyed++
        
        monsterlLabel.text = "\(monstersDestroyed)"
        
        if self.monstersDestroyed % 5 == 0 {
            self.increaseLevel()
        }
    }
    
    func didBeginContact(contact: SKPhysicsContact) {
        
        // 1
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // 2
        if ((firstBody.categoryBitMask & PhysicsCategory.Monster != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
                projectileDidCollideWithMonster(firstBody.node as! SKSpriteNode, monster: secondBody.node as! SKSpriteNode)
        }
        
    }
    
    func delay(delay:Double, closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(delay * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
    
}