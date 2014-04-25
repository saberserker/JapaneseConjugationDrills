//
//  FPNViewBorderColorizer.m
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNViewBorderColorizer.h"

@implementation FPNViewBorderColorizer

- (void)awakeFromNib {
    if (self.templateBorderColor != nil) {
        for (UIView* view in self.coloredViews) {
            view.layer.borderColor = self.templateBorderColor.CGColor;
        }
    }
}

@end
