//
//  FPNViewBorderColorizer.m
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNViewBorderColorizer.h"

@interface FPNViewBorderColorizer ()
@property (nonatomic,strong) CAGradientLayer* gradient;
@end

@implementation FPNViewBorderColorizer

- (void)awakeFromNib {
    if (self.templateBorderColor != nil) {
        for (UIView* view in self.coloredViews) {
            view.layer.borderColor = self.templateBorderColor.CGColor;
        }
    }
}

-(CAGradientLayer*)lazyGradient {
    if (self.gradient == nil) {
        self.gradient = [[CAGradientLayer alloc] init];
        self.gradient.startPoint = CGPointMake(0.5, 0);
        self.gradient.endPoint = CGPointMake(0.5, 1);
        self.gradient.frame = self.bounds;
        [self.layer insertSublayer:self.gradient atIndex:0];
    }
    return self.gradient;
}

- (void)layoutSubviews {
    // resize your layers based on the view's new bounds
    [super layoutSubviews];
    [self lazyGradient].frame = self.bounds;
}

-(void) colorWithHue:(CGFloat)hue {
    UIColor* start = [UIColor colorWithHue:hue saturation:0.7 brightness:0.6 alpha:1];
    UIColor* end = [UIColor colorWithHue:hue saturation:0.3 brightness:0.2 alpha:1];
    [self lazyGradient].colors = [NSArray arrayWithObjects:(id)start.CGColor, (id)end.CGColor,nil];
    
    //randomize gradient direction for style purposes
    self.gradient.startPoint = CGPointMake(0.4 + drand48()*0.2, 0);
    self.gradient.endPoint = CGPointMake(0.4 + drand48()*0.2, 1);
}

@end
