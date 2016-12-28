//
//  VMAGameOverNode.h
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-09.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface VMAGameOverNode : SKNode

+ (instancetype) gameOverAtPosition:(CGPoint)position;

- (void) performAnimation;

@end
