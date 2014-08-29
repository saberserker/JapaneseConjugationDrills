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
    [self setThemeColor: themeHue];
}

- (void) setRandomThemeColorChangeWithDelta:(CGFloat)delta {
    CGFloat themeHue = [self themeColor] + delta * drand48();
    themeHue = fmod(themeHue,1.0);
    if (themeHue < 0) themeHue += 1.0;
    [self setThemeColor: themeHue];
}

- (CGFloat) themeColor {
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    CGFloat theme = [prefs floatForKey:@"userColorHue"];
    
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:theme saturation:0.8 brightness:0.5 alpha:1];
    return theme;
}

- (void) setThemeColor:(CGFloat)theme {
    self.navigationController.navigationBar.tintColor = [UIColor colorWithHue:theme saturation:0.8 brightness:0.5 alpha:1];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:theme forKey:@"userColorHue"];
}

@end
