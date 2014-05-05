//
//  NSArray+Tools.m
//  mudamuda
//
//  Created by Henry Tsang on 5/5/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "NSArray+Tools.h"

@implementation NSArray (Tools)
-(NSMutableArray*) randomizedArray {
    NSMutableArray* retval = [self mutableCopy];
    for (int i = 0; i < retval.count; i++) {
        int r = arc4random_uniform(retval.count);
        [retval exchangeObjectAtIndex:i withObjectAtIndex:r];
    }
    return retval;
}
@end
