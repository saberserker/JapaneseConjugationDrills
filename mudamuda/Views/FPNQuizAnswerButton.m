//
//  FPNQuizAnswerButton.m
//  mudamuda
//
//  Created by Henry Tsang on 4/27/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNQuizAnswerButton.h"

@interface FPNQuizAnswerButton ()
@end

@implementation FPNQuizAnswerButton

-(void) colorWithHue:(CGFloat)hue {
    [self resetButtonWithHue:hue];
}


-(void) resetButtonWithHue:(CGFloat)hue {
    self.backgroundColor = [UIColor colorWithHue:hue saturation:0.2 brightness:0.95 alpha:1];
    self.layer.borderColor = [UIColor colorWithHue:hue saturation:0.7 brightness:0.7 alpha:1].CGColor;
}

-(void) buttonLooksWrong {
    CGFloat hue = 0;
    self.backgroundColor = [UIColor colorWithHue:hue saturation:0.7 brightness:0.95 alpha:0.5];
    self.layer.borderColor = [UIColor colorWithHue:hue saturation:0.9 brightness:0.95 alpha:0.5].CGColor;
    [self animationOscillationTo:CGPointMake(7, 0) from:CGPointMake(-7, 0) cycleSpeed:0.06 cycles:3];
}

-(void) buttonLooksRight {
    CGFloat hue = 0.33;
    self.backgroundColor = [UIColor colorWithHue:hue saturation:0.7 brightness:0.95 alpha:0.7];
    self.layer.borderColor = [UIColor colorWithHue:hue saturation:0.9 brightness:0.95 alpha:0.7].CGColor;
    [self animationOscillationTo:CGPointMake(0, -3) from:CGPointMake(0, -5) cycleSpeed:0.075 cycles:0];
}

-(void) animationOscillationTo:(CGPoint)to from:(CGPoint)from cycleSpeed: (CGFloat) speed cycles:(NSUInteger)cycles{
    [UIView animateWithDuration:speed/2 animations:^{
        CATransform3D currentTransform = self.layer.transform;
        self.layer.transform = CATransform3DTranslate(currentTransform, to.x, to.y, 0);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:speed animations:^{
            self.layer.transform = CATransform3DMakeTranslation(from.x,from.y,0);
        } completion:^(BOOL finished) {
            if (cycles > 1) {
                [self animationOscillationTo:to from:from cycleSpeed:speed cycles:cycles-1];
            } else {
                [UIView animateWithDuration:speed/2 animations:^{
                    self.layer.transform = CATransform3DIdentity;
                }];
            }
        }];
    }];
}
@end
