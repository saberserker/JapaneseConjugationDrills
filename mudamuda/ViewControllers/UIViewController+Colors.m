//
//  UIViewController+Colors.m
//  mudamuda
//
//  Created by htsang on 4/29/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//
#import <objc/runtime.h>
#import "UIViewController+Colors.h"

@implementation UIViewController (Colors)
@dynamic kthemeHue;

- (void) setRandomThemeColor {
    CGFloat themeHue = drand48();
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:themeHue saturation:0.8 brightness:0.5 alpha:1];
    objc_setAssociatedObject(self, @selector(kthemeHue), [NSNumber numberWithFloat:themeHue], OBJC_ASSOCIATION_RETAIN);
}

- (void) setRandomThemeColorChangeWithDelta:(CGFloat)delta {
    CGFloat themeHue = [self themeColor] + delta * drand48();
    themeHue = fmod(themeHue,1.0);
    if (themeHue < 0) themeHue += 1.0;
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:themeHue saturation:0.8 brightness:0.5 alpha:1];
    objc_setAssociatedObject(self, @selector(kthemeHue), [NSNumber numberWithFloat:themeHue], OBJC_ASSOCIATION_RETAIN);
}

- (CGFloat) themeColor {
    NSNumber* themeColor = objc_getAssociatedObject(self, @selector(kthemeHue));
    if (themeColor != nil) {
        return [themeColor floatValue];
    }
    return 0;
}

- (void) setThemeColor:(CGFloat)theme {
    objc_setAssociatedObject(self, @selector(kthemeHue), [NSNumber numberWithFloat:theme], OBJC_ASSOCIATION_RETAIN);
}

@end
