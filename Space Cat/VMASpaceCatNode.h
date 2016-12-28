//
//  VMASpaceCatNode.h
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-03.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface VMASpaceCatNode : SKSpriteNode

+ (instancetype) spaceCatAtPosition:(CGPoint)position;

- (void) performTap;

@end
