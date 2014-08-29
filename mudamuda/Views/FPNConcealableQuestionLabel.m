//
//  FPNConcealableQuestionLabel.m
//  mudamuda
//
//  Created by Henry Tsang on 8/29/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNConcealableQuestionLabel.h"
@interface FPNConcealableQuestionLabel()
@property (nonatomic, strong) NSString* concealedText;
@property (nonatomic, strong) UIFont* defaultFont;

@end


@implementation FPNConcealableQuestionLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) toggleConcealed {
    self.concealed = !self.concealed;
    
    if (self.defaultFont == nil) {
        self.defaultFont = self.font;
    }
    
    if (self.concealed) {
        [super setText:@"(tap to unhide information)"];
        self.font = [UIFont italicSystemFontOfSize:15];
        self.textColor = [UIColor yellowColor];
    } else {
        [super setText:self.concealedText];
        self.font = self.defaultFont;
        self.textColor = [UIColor whiteColor];
    }
}

- (void) setText:(NSString *)text {
    self.concealedText = text;
    if (!self.concealed) {
        [super setText:text];
    }
}


@end
