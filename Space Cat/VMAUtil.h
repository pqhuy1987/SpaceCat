//
//  VMAUtil.h
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-04.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import <Foundation/Foundation.h>

static const int VMAProjectileSpeed = 400;
static const int VMASpaceDogMinSpeed = -100;
static const int VMASpaceDogMaxSpeed = -50;
static const int VMAMaxLives = 4;
static const int VMAPointsPerHit = 100;

typedef NS_OPTIONS(uint32_t, VMACollisionCategory) {
    
    VMACollisionCategoryEnemy =         1 << 0,  // 0000
    VMACollisionCategoryProjectile =    1 << 1,  // 0010
    VMACollisionCategoryDebris =        1 << 2,  // 0100
    VMACollisionCategoryGround =        1 << 3   // 1000
};

@interface VMAUtil : NSObject

+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max;

@end
