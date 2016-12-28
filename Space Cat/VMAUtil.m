//
//  VMAUtil.m
//  Space Cat
//
//  Created by Vince Abruzzese on 2014-09-04.
//  Copyright (c) 2014 Vince Abruzzese. All rights reserved.
//

#import "VMAUtil.h"

@implementation VMAUtil


//WE define a method here to generate us a random number
+ (NSInteger) randomWithMin:(NSInteger)min max:(NSInteger)max {
    return arc4random()%(max - min) + min;
}

@end
