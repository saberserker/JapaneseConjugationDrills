//
//  FPNViewBorderColorizer.h
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPNViewBorderColorizer : UIView
@property (nonatomic,strong) UIColor * templateBorderColor;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *coloredViews;
-(void) colorWithHue:(CGFloat)hue;
@end
