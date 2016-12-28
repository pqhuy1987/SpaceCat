//
//  VMASpaceDogNode.h
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-04.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSUInteger, VMASpaceDogType) {
    VMASpaceDogTypeA = 0,
    VMASpaceDogTypeB = 1,
};

@interface VMASpaceDogNode : SKSpriteNode

+ (instancetype) spaceDogOfType:(VMASpaceDogType)type;

@end
