//
//  FPNQuizAnswerButton.h
//  mudamuda
//
//  Created by Henry Tsang on 4/27/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPNQuizAnswerButton : UIButton
-(void) resetButtonWithHue:(CGFloat)hue;
-(void) buttonLooksWrong;
-(void) buttonLooksRight;

-(void) shadowOpacityTo:(CGFloat)alpha from:(CGFloat)fromAlpha;
@end
