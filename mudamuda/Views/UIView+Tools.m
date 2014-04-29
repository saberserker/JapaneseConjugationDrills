//
//  UIView+Tools.m
//  mudamuda
//
//  Created by Henry Tsang on 4/28/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "UIView+Tools.h"
#import <objc/runtime.h>

@implementation UIView (Tools)
@dynamic childGradient;

//color gradient methods
-(CAGradientLayer*)lazyGradient {
    CAGradientLayer* gradient = objc_getAssociatedObject(self, @selector(childGradient));
    if (gradient == nil) {
        gradient = [[CAGradientLayer alloc] init];
        gradient.startPoint = CGPointMake(0.5, 0);
        gradient.endPoint = CGPointMake(0.5, 1);
        gradient.frame = self.bounds;
        gradient.cornerRadius = self.layer.cornerRadius;
        gradient.opacity = 0;
        [self.layer addSublayer:gradient];
        [self.layer setValue:gradient forKey:@"FPNchildGradient"];
        
        UIColor* start = [UIColor colorWithWhite:0 alpha:1];
        UIColor* end = [UIColor colorWithWhite:0 alpha:1];
        gradient.colors = [NSArray arrayWithObjects:(id)start.CGColor, (id)end.CGColor,nil];
        objc_setAssociatedObject(self, @selector(childGradient), gradient, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gradient;
}

-(void) shadowOpacityTo:(CGFloat)alpha from:(CGFloat)fromAlpha{
    [[self lazyGradient] removeAllAnimations];
    CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flash.fromValue = [NSNumber numberWithFloat:fromAlpha];
    flash.toValue = [NSNumber numberWithFloat:alpha];
    flash.duration = 0.4;
    flash.removedOnCompletion = NO;
    [[self lazyGradient] addAnimation:flash forKey:@"shadowAni"];
}

@end
