//
//  VMAGamePlayScene.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-02.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMAGamePlayScene.h"
#import "VMAMachineNode.h"
#import "VMASpaceCatNode.h"
#import "VMAProjectileNode.h"
#import "VMASpaceDogNode.h"
#import "VMAGroundNode.h"
#import "VMAUtil.h"
#import <AVFoundation/AVFoundation.h>
#import "VMAHudNode.h"
#import "VMAGameOverNode.h"

@interface VMAGamePlayScene ()

@property (nonatomic) NSTimeInterval lastUpdateTimeInterval; //keeps track of last time interval
@property (nonatomic) NSTimeInterval timeSinceEnemyAdded;
@property (nonatomic) NSTimeInterval totalGameTime;
@property (nonatomic) NSInteger minSpeed;
@property (nonatomic) NSTimeInterval addEnemyTimeInterval;
@property (nonatomic) SKAction *damageSFX;
@property (nonatomic) SKAction *explodeSFX;
@property (nonatomic) SKAction *laserSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;
@property (nonatomic) AVAudioPlayer *gameOverMusic;
@property (nonatomic) BOOL gameOver;
@property (nonatomic) BOOL restart;
@property (nonatomic) BOOL gameOverDisplayed;

//keeps track of when enemy was added last

@end


@implementation VMAGamePlayScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        self.lastUpdateTimeInterval = 0;
        self.timeSinceEnemyAdded = 0;
        self.addEnemyTimeInterval = 1.5;
        self.totalGameTime = 0;
        self.minSpeed = VMASpaceDogMinSpeed;
        self.gameOver = NO;
        self.restart = NO;
        self.gameOverDisplayed = NO;
        
        //Add the background
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"background_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:background];
        
        //Add the machine
        VMAMachineNode *machine = [VMAMachineNode machineAtPosition:CGPointMake(CGRectGetMidX(self.frame), 12)];
        [self addChild:machine];
        
        //Add the Space Cat:
        VMASpaceCatNode *spaceCat = [VMASpaceCatNode spaceCatAtPosition:CGPointMake(machine.position.x, machine.position.y - 2)];
        [self addChild:spaceCat];
        
        //Here we add the physics to the game. VMAGameplayScene now has gravity acted on the
        //nodes that are declared (defined with physics body).
        self.physicsWorld.gravity = CGVectorMake(0, -9.8);

        self.physicsWorld.contactDelegate = self; //scene is delegate for SKPhysicsContactDelegate
        
        //Add the ground node with the physics body (needed for when dogs reach the ground)
        VMAGroundNode *ground = [VMAGroundNode groundWithSize:CGSizeMake(self.frame.size.width, 22)];
        [self addChild:ground];
        
        [self setupSounds];
        
        VMAHudNode *hud = [VMAHudNode hudAtPosition:CGPointMake(0, self.frame.size.height - 20) inFrame:self.frame];
        [self addChild:hud];
    }
    return self;
}

- (void) didMoveToView:(SKView *)view {
    
    [self.backgroundMusic play];
}

-(void) setupSounds {
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"Gameplay" withExtension:@"mp3"];
    
    self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    
    self.backgroundMusic.numberOfLoops = -1;
    [self.backgroundMusic prepareToPlay];
    
    NSURL *gameOverURL = [[NSBundle mainBundle] URLForResource:@"GameOver" withExtension:@"mp3"];
    
    self.gameOverMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:gameOverURL error:nil];
    self.gameOverMusic.numberOfLoops = 1;
    [self.gameOverMusic prepareToPlay];
    
    self.damageSFX = [SKAction playSoundFileNamed:@"Damage.caf" waitForCompletion:NO];
    self.laserSFX = [SKAction playSoundFileNamed:@"Laser.caf" waitForCompletion:NO];
    self.explodeSFX = [SKAction playSoundFileNamed:@"Explode.caf" waitForCompletion:NO];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{

    if (!self.gameOver){
    
    //Get position and execute shootProjectileTowardsPosition method
    for (UITouch *touch in touches) {
        CGPoint position = [touch locationInNode:self];
        //method to determine where you touched
        
        [self shootProjectileTowardsPosition:position];
        //with the touched position it will calculate the slope and movement of projectile
        //moveTowardsPosition will actually move the projectile. It is called in the method below
        }
    } else if (self.restart) {
        
        for (SKNode *node in [self children]){
            [node removeFromParent];
        }
        
        VMAGamePlayScene *scene = [VMAGamePlayScene sceneWithSize:self.view.bounds.size];
        [self.view presentScene:scene];
    }
}

-(void) performGameOver {
    
    VMAGameOverNode *gameOver = [VMAGameOverNode gameOverAtPosition:CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))];
    [self addChild:gameOver];
    self.restart = YES;
    self.gameOverDisplayed = YES;
    
    [gameOver performAnimation];
    
    [self.backgroundMusic stop];
    [self.gameOverMusic play];
}

-(void) shootProjectileTowardsPosition:(CGPoint) position {
    
    //Cat movement
    VMASpaceCatNode *spaceCat = (VMASpaceCatNode*)[self childNodeWithName:@"SpaceCat"];
    [spaceCat performTap];
    
    //Create a pointer to the machine so we can use the x and y coordinates in our projectile
    VMAMachineNode *machine = (VMAMachineNode *)[self childNodeWithName:@"Machine"];
    
    //Create the projectile node with the position value from touch to be used to calculate
    //a slope for the fireball that will be fired
    VMAProjectileNode *projectile = [VMAProjectileNode projectileAtPosition:CGPointMake(machine.position.x, machine.position.y + machine.frame.size.height - 15)];
    
    //We will add the projectile and call the function to move it
    [self addChild:projectile];
    [projectile moveTowardsPosition:position];
    
    [self runAction:self.laserSFX];
    
}

-(void) addSpaceDog {
   
    NSUInteger randomSpaceDog = [VMAUtil randomWithMin:0 max:2];
    
    VMASpaceDogNode *spaceDog = [VMASpaceDogNode spaceDogOfType:randomSpaceDog];
    float dy = [VMAUtil randomWithMin:VMASpaceDogMinSpeed max:VMASpaceDogMaxSpeed];
    spaceDog.physicsBody.velocity = CGVectorMake(0, dy);
    
    float y = self.frame.size.height + spaceDog.size.height;
    float x = [VMAUtil randomWithMin:10 + spaceDog.size.width max:self.frame.size.width- spaceDog.size.width - 10];
    
    spaceDog.position = CGPointMake(x,y);
    [self addChild:spaceDog];

}

-(void) update:(NSTimeInterval)currentTime{
    
    if (self.lastUpdateTimeInterval){ //checks if there exists a last time interval
        self.timeSinceEnemyAdded += currentTime - self.lastUpdateTimeInterval;
        self.totalGameTime += currentTime - self.lastUpdateTimeInterval;
    } //checking to see how many seconds since last game run loop executed and adding to timeSinceEnemy property
    
    if (self.timeSinceEnemyAdded > self.addEnemyTimeInterval && !self.gameOver) {
        [self addSpaceDog]; //If that time is greater than 0 we add a new space dog
        self.timeSinceEnemyAdded = 0;
    }
    
    self.lastUpdateTimeInterval = currentTime;
    
    if (self.totalGameTime > 480){
        //480 / 60 = 8 minutes
        self.addEnemyTimeInterval = 0.5;
        self.minSpeed = -160;
        
    } else if (self.totalGameTime > 240){
        //240 / 60 = 4 minutes
        self.addEnemyTimeInterval = 0.65;
        self.minSpeed = -150;
        
    } else if (self.totalGameTime > 120){
        //120 / 60 = 2 minutes
        self.addEnemyTimeInterval = 0.75;
        self.minSpeed = -125;
        
    } else if (self.totalGameTime > 30){
        
        self.addEnemyTimeInterval = 1;
        self.minSpeed = -100;
        
    }
    
    if (self.gameOver && !self.gameOverDisplayed) {
        [self performGameOver];
    }
    
}

-(void) didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    } else {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody.categoryBitMask == VMACollisionCategoryEnemy && secondBody.categoryBitMask == VMACollisionCategoryProjectile) {
        
        VMASpaceDogNode *spaceDog = (VMASpaceDogNode*)firstBody.node;
        VMAProjectileNode *projectile = (VMAProjectileNode*)secondBody.node;
        
        [self addPoints:VMAPointsPerHit];
        
        [self runAction:self.explodeSFX];
        
        [spaceDog removeFromParent];
        [projectile removeFromParent];
        
    } else if (firstBody.categoryBitMask == VMACollisionCategoryEnemy && secondBody.categoryBitMask == VMACollisionCategoryGround) {
        
        VMASpaceDogNode *spaceDog = (VMASpaceDogNode*)firstBody.node;

        [self runAction:self.damageSFX];
        
        [spaceDog removeFromParent];
        
        [self loseLife];
    }
    
    [self createDebrisAtPosition:contact.contactPoint];
    
    
}

-(void) loseLife {
    VMAHudNode *hud = (VMAHudNode*)[self childNodeWithName:@"HUD"];
    self.gameOver = [hud loseLife];
}

-(void) addPoints:(NSInteger)points{
    VMAHudNode *hud = (VMAHudNode*)[self childNodeWithName:@"HUD"];
    [hud addPoints:points];
}

- (void) createDebrisAtPosition:(CGPoint)position {
    
    //Generate a random number of debris between 5 and 20
    NSInteger numberOfPieces = [VMAUtil randomWithMin:5 max:20];
    
    for (int i = 0 ; i < numberOfPieces; i++){
        
        //We will select one of the 3 types of debris
        NSInteger randomPiece = [VMAUtil randomWithMin:1 max:4];
        NSString *imageName = [NSString stringWithFormat:@"debri_%d",randomPiece];
        
        //We add the debris here
        SKSpriteNode *debris = [SKSpriteNode spriteNodeWithImageNamed:imageName];
        debris.position = position;
        [self addChild:debris];
        
        //Give the debris some physics. Set it to collide with ground and other debris
        debris.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:debris.frame.size];
        debris.physicsBody.categoryBitMask = VMACollisionCategoryDebris;
        debris.physicsBody.contactTestBitMask = 0;
        debris.physicsBody.collisionBitMask = VMACollisionCategoryGround| VMACollisionCategoryDebris;
        debris.name = @"Debris";
        
        //To give the explosion effect we give it some velocity randomly
        debris.physicsBody.velocity = CGVectorMake([VMAUtil randomWithMin:-150 max: 150], [VMAUtil randomWithMin:150 max:350]);
        
        //After 2 seconds we remove the debris from the game
        [debris runAction:[SKAction waitForDuration:2.0] completion:^{
            [debris removeFromParent];
        }];
        
    } //Continue this in the for loop until we reach the number of pieces

    NSString *explosionPath = [[NSBundle mainBundle] pathForResource:@"Explosion" ofType:@"sks"];
    SKEmitterNode *explosion = [NSKeyedUnarchiver unarchiveObjectWithFile:explosionPath];
    explosion.position = position;
    [self addChild:explosion];
    
    [explosion runAction:[SKAction waitForDuration:2.0] completion:^{
        [explosion removeFromParent];
    }];
}


@end
