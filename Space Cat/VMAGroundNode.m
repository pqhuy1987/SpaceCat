//
//  VMAGroundNode.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-04.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMAGroundNode.h"
#import "VMAUtil.h"

@implementation VMAGroundNode

+ (instancetype) groundWithSize:(CGSize)size {
    
    VMAGroundNode *ground = [self spriteNodeWithColor:[SKColor clearColor] size:size];
    ground.name = @"Ground";
    ground.position = CGPointMake(size.width/2, size.height/2);
    [ground setupPhysicsBody];
    
    return ground;
}

- (void) setupPhysicsBody {
    self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
    self.physicsBody.affectedByGravity = NO;
    self.physicsBody.dynamic = NO;
    //Dynamic here makes ground unaffected by any nodes (wont move)
    
    self.physicsBody.categoryBitMask = VMACollisionCategoryGround; //the category
    self.physicsBody.collisionBitMask = VMACollisionCategoryDebris; //what is collides with
    self.physicsBody.contactTestBitMask = VMACollisionCategoryEnemy; //what is contacts with
    
}

@end
