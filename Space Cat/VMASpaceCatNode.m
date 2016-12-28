//
//  VMASpaceCatNode.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-03.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMASpaceCatNode.h"

@interface VMASpaceCatNode () //Empty category on class to define private properties

@property (nonatomic) SKAction *tapAction;

@end

@implementation VMASpaceCatNode

+ (instancetype) spaceCatAtPosition:(CGPoint)position {
    
    //Creates the space cat and places it in middle of machine. Is created in VMAGamePlayScene
    VMASpaceCatNode *spaceCat = [self spriteNodeWithImageNamed:@"spacecat_1"];
    spaceCat.position = position;
    spaceCat.anchorPoint = CGPointMake(0.5, 0);
    spaceCat.name = @"SpaceCat";
    spaceCat.zPosition = 9;
    
    return spaceCat;
    
}


//Executed in the shootProjectileTowardsPosition method which is called in touchesBegan which
//will run everytime there is a touch event
-(void) performTap {
    [self runAction:self.tapAction];
}


- (SKAction *) tapAction {
  
    //To avoid destroying and creating array over and over, we check first if array of textures
    //have already been created.
    if (_tapAction != nil){
        return _tapAction;
    }
    
    //If it is in fact nil we know that they haven't been created so we must therefore create
    //them
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"spacecat_2"],
                          [SKTexture textureWithImageNamed:@"spacecat_1"]];
    _tapAction = [SKAction animateWithTextures:textures timePerFrame:0.25];
   //we set the time frame here as the speed of the animation of the cat tapping the button
    
    return _tapAction;
    //the _tapAction is an instance of tapAction
    
}

@end
