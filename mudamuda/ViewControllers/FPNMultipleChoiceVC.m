//
//  FPNMultipleChoiceVC.m
//  mudamuda
//
//  Created by Henry Tsang on 4/22/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNMultipleChoiceVC.h"
#import "FPNAllRomanjiForKana.h"
#import "FPNQuizAnswerButton.h"
#import "FPNViewBorderColorizer.h"
#import "UIView+Tools.h"
#import "UIViewController+Colors.h"

@interface FPNMultipleChoiceVC ()
@property (weak, nonatomic) IBOutlet UITextView *questionView;
@property (strong, nonatomic) IBOutletCollection(FPNQuizAnswerButton) NSArray *answerButton;
@end

@implementation FPNMultipleChoiceVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    for (UIButton* b in self.answerButton) {
        [b addTarget:self action:@selector(answerPushed:) forControlEvents:UIControlEventTouchUpInside];
    }
    srand48(time(0));
    [self setupThemeColors];
    [self setupQuestions];
}

- (void) setupThemeColors {
    CGFloat themeHue = self.themeColor;
    self.questionView.backgroundColor = [UIColor colorWithHue:themeHue saturation:0.4 brightness:0.8 alpha:1];
    self.questionView.layer.borderColor = [UIColor colorWithHue:themeHue saturation:0.8 brightness:0.7 alpha:1].CGColor;
    for (FPNQuizAnswerButton* button in self.answerButton) {
        [button resetButtonWithHue:themeHue];
    }
    
    FPNViewBorderColorizer* background = (FPNViewBorderColorizer*)self.view;
    [background colorWithHue:themeHue];
}

static BOOL correctAnswerSelected;
- (void) setupQuestions {
    correctAnswerSelected = false;
    
    NSMutableArray* randomButtons = [[NSMutableArray alloc] initWithArray:self.answerButton];
    for (int i = 0; i < randomButtons.count; i++) {
        [randomButtons exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(randomButtons.count)];
    }
    
    [self.quizGenerator generateMultipleChoice:^(NSString *question, NSArray *possibleAnswers) {
        self.questionView.text = question;
        [self.questionView setFont:[UIFont boldSystemFontOfSize:30]];
        [self.questionView setTextAlignment:NSTextAlignmentCenter];

        for (int i = 0; i < MIN(possibleAnswers.count, randomButtons.count); i++) {
            UIButton* button = ((UIButton*)randomButtons[i]);
            button.titleLabel.adjustsFontSizeToFitWidth = YES;
           [button setTitle:((NSString*)possibleAnswers[i]) forState:UIControlStateNormal];
        }
    }];
}

- (void) setupQuestionsWithAnimation {
    CATransform3D flattened3d = CATransform3DIdentity;
    flattened3d.m22 = 0.001;
    flattened3d.m24 = -0.000005;
    
    NSRange viewRange = [self rangeBasedOnCollectionOfViews:self.answerButton];
    
    for (FPNQuizAnswerButton* b in self.answerButton) {
        CGFloat animTime = 0.05 + 0.35 * [self stepBasedOnRange:viewRange forView:b];
        [UIView animateWithDuration:animTime animations:^{
            CATransform3D bt = flattened3d;
            bt.m42 = 100;
            b.layer.transform = bt;
        }];
    }
    
    [self.view layoutSubviews];
    [UIView animateWithDuration:0.4 animations:^{
        self.questionView.layer.transform = flattened3d;
        [self.questionView shadowOpacityTo:0.5 from:0];
        
        [self setRandomThemeColorChangeWithDelta:0.1];
        [self setupThemeColors];
        [self.view layoutSubviews];

    } completion:^(BOOL finished) {
        [self setupQuestions];
        CATransform3D flattenedover3d = flattened3d;
        flattenedover3d.m24 = 0.000005;
        //animate self.questionView
        self.questionView.layer.transform = flattenedover3d;
        [UIView animateWithDuration:0.4 animations:^{
            self.questionView.layer.transform = CATransform3DIdentity;
            [self.view layoutSubviews];
        }];
        [self.questionView shadowOpacityTo:0 from:0.5];
        for (FPNQuizAnswerButton* b in self.answerButton) {
            b.layer.transform = CATransform3DMakeTranslation(1000, 0, 0);
            CGFloat animTime = 0.37 + 0.3 * [self stepBasedOnRange:viewRange forView:b];
            [UIView animateWithDuration:animTime animations:^{
                [self.view layoutSubviews];
                b.layer.transform = CATransform3DIdentity;
            }];
        }
    }];
}

- (NSRange) rangeBasedOnCollectionOfViews:(NSArray*) views {
    NSUInteger min = NSUIntegerMax;
    NSUInteger max = 0;
    for (UIView* v in views) {
        CGFloat val = v.center.x + v.center.y;
        min = MIN(min, val);
        max = MAX(max, val);
    }
    return NSMakeRange(min, max);
}

- (CGFloat) stepBasedOnRange:(NSRange) range forView:(UIView*)v {
    CGFloat val = v.center.x + v.center.y;
    NSUInteger min = range.location;
    NSUInteger max = range.length;
    CGFloat retval = (val - min) / (max - min);
    return MAX(MIN(retval, 1),0);
}

- (IBAction)answerPushed: (FPNQuizAnswerButton*) sender {
    if (correctAnswerSelected) {
        [self setupQuestionsWithAnimation];
        return;
    }
    
    if ([self.quizGenerator is:sender.titleLabel.text correctforQuestion: self.questionView.text]) {
        [sender buttonLooksRight];
        correctAnswerSelected = YES;
    } else {
        [sender buttonLooksWrong];
    }
}

@end
