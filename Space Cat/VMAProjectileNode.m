//
//  VMAProjectileNode.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-04.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMAProjectileNode.h"
#import "VMAUtil.h"

@implementation VMAProjectileNode

+(instancetype) projectileAtPosition:(CGPoint) position {
    
    //This will create the projectile initially with position but no animation
    VMAProjectileNode *projectile = [self spriteNodeWithImageNamed:@"projectile_1"];
    projectile.position = position;
    projectile.name = @"Projectile";
    
    //This will setup the animation but no movement (moveTowardsPosition below will set movement)
    [projectile setupAnimation];
    
    [projectile setupPhysicsBody];
    
    return projectile;
}

//We set up the physics body separately. Size is taken from frame of image
-(void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    
    self.physicsBody.categoryBitMask = VMACollisionCategoryProjectile;
    self.physicsBody.collisionBitMask = 0; //Projectile doesnt collide with anything
    self.physicsBody.contactTestBitMask = VMACollisionCategoryEnemy;
}

-(void) setupAnimation {
    
    //As done previously we create the animation by using several different pictures with
    //small variations. The SKTexture is set up in an array with these images
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"projectile_1"],
                          [SKTexture textureWithImageNamed:@"projectile_2"],
                          [SKTexture textureWithImageNamed:@"projectile_3"]];
    
    //animate with textures will determine how long the animation should be
    SKAction *animation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    //repeatActionForever is self-explanatory, will continue forever
    SKAction *repeatAction = [SKAction repeatActionForever:animation];
    [self runAction:repeatAction];
}

- (void) moveTowardsPosition:(CGPoint)position {
    
    //slope = (Y3 - Y1) / (X3 - X1)
    float slope = (position.y - self.position.y) / (position.x - self.position.x);
    
    //slope = (Y2 - Y1) / (X2 -X1)
    // Y2 = slope * X2 - slope * X1 + Y1
    
    float offscreenX;
    
    //Depending on where you click (left or right) the offsetX will be one or the other.
    //We use and if statement to determine which side it will be
    if (position.x <= self.position.x){
        offscreenX = -10;
    } else {
        offscreenX = self.parent.frame.size.width + 10;
    }
    
    //The offscreenY is determined by isolating the Y2 and calculating it from the slope formula
    float offscreenY = slope * offscreenX - slope * self.position.x + self.position.y;
    
    //We make a point with the two offscreen points
    CGPoint pointOffscreen = CGPointMake(offscreenX, offscreenY);
    
    //We calculate the distance with Pythagorus theorem to determine distance, used to determine
    //time of animation
    float distanceA = pointOffscreen.y - self.position.y;
    float distanceB = pointOffscreen.x - self.position.x;
    
    float distanceC = sqrtf(powf(distanceA, 2) + pow(distanceB, 2));
    
    //distance = speed * time
    //time = distance /speed
    
    float time = distanceC / VMAProjectileSpeed; //We define this is VMAUtil header file
    float waitToFade = time * 0.75; //We want to wait till we are 75% of the screen
    float fadeTime = time - waitToFade; //subtract the wait for the remaining 0.25 to fade
    
    SKAction *moveProjectile = [SKAction moveTo:pointOffscreen duration:time];
    [self runAction:moveProjectile];
    
    //We make an array of SKActions to run one action after the other. We can use sequence to
    //do this
    NSArray *sequence = @[[SKAction waitForDuration:waitToFade],
                          [SKAction fadeOutWithDuration:fadeTime],
                          [SKAction removeFromParent]]; //This removes the node afterward
    
    //With run action we will run each SKAction in the array
    [self runAction:[SKAction sequence:sequence]];
    
}

@end
