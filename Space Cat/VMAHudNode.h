//
//  VMAHudNode.h
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-08.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface VMAHudNode : SKNode

@property (nonatomic) NSInteger lives;
@property (nonatomic) NSInteger score;

+ (instancetype) hudAtPosition:(CGPoint)position inFrame:(CGRect)frame;

- (void) addPoints:(NSInteger)points;
- (BOOL) loseLife;

@end
