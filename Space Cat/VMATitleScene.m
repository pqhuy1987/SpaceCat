//
//  VMATitleScene.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-02.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMATitleScene.h"
#import "VMAGamePlayScene.h"
#import <AVFoundation/AVFoundation.h>

@interface VMATitleScene ()

@property (nonatomic) SKAction *pressStartSFX;
@property (nonatomic) AVAudioPlayer *backgroundMusic;

@end

@implementation VMATitleScene

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        
        //Add the main menu
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"splash_1"];
        background.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        //since anchor for this is middle we get middle of screen
        
        [self addChild:background];
        
        self.pressStartSFX = [SKAction playSoundFileNamed:@"PressStart.caf" waitForCompletion:NO];
        
        NSURL *url = [[NSBundle mainBundle] URLForResource:@"StartScreen" withExtension:@"mp3"];
        
        self.backgroundMusic = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        self.backgroundMusic.numberOfLoops = -1;
        [self.backgroundMusic prepareToPlay];
        
    }
    return self;
}

- (void) didMoveToView:(SKView *)view {
    
    [self.backgroundMusic play];
}

- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [self.backgroundMusic stop];
    
    [self runAction:self.pressStartSFX];
    
    VMAGamePlayScene *gamePlayScene = [VMAGamePlayScene sceneWithSize:self.frame.size];
    
    //Once the user taps we use SKTransition to Transition to the gameplay scene. We can select
    //whatever duration we want this transition to take
    SKTransition *transition = [SKTransition fadeWithDuration:1.0];
    
    //Change presentScene to the next scene and transition type which was defined above
    [self.view presentScene:gamePlayScene transition:transition];
}

@end
