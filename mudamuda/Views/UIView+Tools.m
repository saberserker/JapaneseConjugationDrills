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

//color gradient methods
-(CAGradientLayer*)lazyGradient {
    CAGradientLayer* gradient = [self.layer valueForKey:@"FPNchildGradient"];
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
    }
    return gradient;
}

-(void) shadowOpacityTo:(CGFloat)alpha from:(CGFloat)fromAlpha{
    CAGradientLayer* gradient = [self lazyGradient];
    [UIView performWithoutAnimation:^{
        gradient.frame = self.bounds;
    }];
    
    [gradient removeAllAnimations];
    CABasicAnimation *flash = [CABasicAnimation animationWithKeyPath:@"opacity"];
    flash.fromValue = [NSNumber numberWithFloat:fromAlpha];
    flash.toValue = [NSNumber numberWithFloat:alpha];
    flash.duration = 0.4;
    flash.removedOnCompletion = NO;
    [gradient addAnimation:flash forKey:@"shadowAni"];
}

@end
