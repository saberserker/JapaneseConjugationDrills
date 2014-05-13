//
//  UIView+Tools.h
//  mudamuda
//
//  Created by Henry Tsang on 4/28/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Tools)
-(void) shadowOpacityTo:(CGFloat)alpha from:(CGFloat)fromAlpha;
-(CAGradientLayer*)shineGradient;
@end
