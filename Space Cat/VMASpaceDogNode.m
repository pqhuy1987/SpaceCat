//
//  VMASpaceDogNode.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-04.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMASpaceDogNode.h"
#import "VMAUtil.h"

@implementation VMASpaceDogNode

+ (instancetype) spaceDogOfType:(VMASpaceDogType)type {
    
    VMASpaceDogNode *spaceDog;
    
    NSArray *textures;
    
    if (type == VMASpaceDogTypeA) {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_A_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_A_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_A_3"]];
    } else {
        spaceDog = [self spriteNodeWithImageNamed:@"spacedog_B_1"];
        textures = @[[SKTexture textureWithImageNamed:@"spacedog_B_1"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_2"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_3"],
                     [SKTexture textureWithImageNamed:@"spacedog_B_4"]];
    }

    float scale = [VMAUtil randomWithMin:85 max:100] / 100.0f; //To get float number
    spaceDog.xScale = scale;
    spaceDog.yScale = scale; //Assigns the scale to a value between 0.85 and 1 making the enemies smaller or bigger
    
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    [spaceDog runAction:[SKAction repeatActionForever:animation]];
    
    [spaceDog setupPhysicsBody];
    
    return spaceDog;
}

//We set up the physics for the space dog, will not be affected by gravity. instead we set a
// velocity with a certain speed.
-(void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.categoryBitMask = VMACollisionCategoryEnemy;
    self.physicsBody.collisionBitMask = 0;
    self.physicsBody.contactTestBitMask = VMACollisionCategoryProjectile | VMACollisionCategoryGround; // 0010 | 1000 = 1010
}

@end
