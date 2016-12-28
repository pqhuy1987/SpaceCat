//
//  VMAMachineNode.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-03.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMAMachineNode.h"

@implementation VMAMachineNode

+ (instancetype) machineAtPosition:(CGPoint)position {
    
    //Creates machine with animations at a given position. Is created in VMAGamePlayScene
    VMAMachineNode *machine = [self spriteNodeWithImageNamed:@"machine_1"];
    machine.position = position;
    machine.anchorPoint = CGPointMake(0.5, 0);
    machine.name = @"Machine";
    machine.zPosition = 8;
    
    NSArray *textures = @[[SKTexture textureWithImageNamed:@"machine_1"],
                          [SKTexture textureWithImageNamed:@"machine_2"]];
    
    SKAction *machineAnimation = [SKAction animateWithTextures:textures timePerFrame:0.1];
    
    SKAction *machineRepeat = [SKAction repeatActionForever:machineAnimation];
    [machine runAction:machineRepeat];
    
    return machine;
}

@end
