//
//  UIViewController+Colors.h
//  mudamuda
//
//  Created by htsang on 4/29/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Colors)
@property (nonatomic, assign) NSNumber* kthemeHue;
- (void) setRandomThemeColor;
- (void) setRandomThemeColorChangeWithDelta:(CGFloat)delta;
- (CGFloat) themeColor;
- (void) setThemeColor:(CGFloat)theme;
@end
