//
//  FPNConcealableQuestionLabel.h
//  mudamuda
//
//  Created by Henry Tsang on 8/29/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FPNConcealableQuestionLabel : UILabel
@property IBInspectable (nonatomic, assign) BOOL concealed;
@property IBInspectable (nonatomic, assign) NSInteger defaultFontSize;
- (void) toggleConcealed;
@end
