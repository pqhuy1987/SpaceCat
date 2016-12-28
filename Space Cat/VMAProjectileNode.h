//
//  VMAProjectileNode.h
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-04.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface VMAProjectileNode : SKSpriteNode

+(instancetype) projectileAtPosition:(CGPoint) position;
-(void) moveTowardsPosition:(CGPoint)position;

@end
