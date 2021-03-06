//
//  FPNMultipleChoiceVC.m
//  mudamuda
//
//  Created by Henry Tsang on 4/22/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNMultipleChoiceVC.h"
#import "FPNAllRomanjiForKana.h"
#import "FPNViewBorderColorizer.h"
#import "UIView+Tools.h"
#import "UIViewController+Colors.h"

@interface FPNMultipleChoiceVC ()
@property (strong, nonatomic) IBOutlet UIView *questionLabelBackgroundView;
@property (weak, nonatomic) IBOutlet UILabel *questionLabel;
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
    for (FPNQuizAnswerButton* button in self.answerButton) {
        [button resetButtonWithHue:themeHue];
    }
    
    FPNViewBorderColorizer* background = (FPNViewBorderColorizer*)self.view;
    [background colorWithHue:themeHue];
}

- (void) setupQuestions {
    self.correctAnswerSelected = false;
    
    [self.quizGenerator generateMultipleChoice:^(NSString *question, NSArray *possibleAnswers) {
        self.questionLabel.text = question;
        [self assignToButtonsPossibleAnswers:possibleAnswers];
    }];
}

- (void) assignToButtonsPossibleAnswers:(NSArray*)possibleAnswers {
    NSMutableArray* randomButtons = [[NSMutableArray alloc] initWithArray:self.answerButton];
    for (int i = 0; i < randomButtons.count; i++) {
        [randomButtons exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(randomButtons.count)];
    }
    for (int i = 0; i < MIN(possibleAnswers.count, randomButtons.count); i++) {
        UIButton* button = ((UIButton*)randomButtons[i]);
        button.titleLabel.adjustsFontSizeToFitWidth = YES;
        [button setTitle:((NSString*)possibleAnswers[i]) forState:UIControlStateNormal];
    }
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
        self.questionLabel.layer.transform = flattened3d;
        self.questionLabelBackgroundView.layer.transform = CATransform3DScale(flattened3d, 2, 1, 1);
        [self.questionLabelBackgroundView shadowOpacityTo:0.5 from:0];
        
        [self setupThemeColors];
        [self.view layoutSubviews];

    } completion:^(BOOL finished) {
        [self setupQuestions];
        CATransform3D flattenedover3d = flattened3d;
        flattenedover3d.m24 = 0.000005;
        //animate questionLabel
        self.questionLabel.layer.transform = flattenedover3d;
        self.questionLabelBackgroundView.layer.transform = CATransform3DScale(flattenedover3d, 2, 1, 1);
        [UIView animateWithDuration:0.4 animations:^{
            self.questionLabel.layer.transform = CATransform3DIdentity;
            self.questionLabelBackgroundView.layer.transform = CATransform3DIdentity;
            [self.view layoutSubviews];
        }];
        [self.questionLabelBackgroundView shadowOpacityTo:0 from:0.5];
        for (FPNQuizAnswerButton* b in self.answerButton) {
            b.layer.transform = CATransform3DMakeTranslation(1000, 0, 0);
            CGFloat animTime = 0.37 + 0.3 * [self stepBasedOnRange:viewRange forView:b];
            [UIView animateWithDuration:animTime animations:^{
                [self.view layoutSubviews];
                b.layer.transform = CATransform3DIdentity;
            } completion:^(BOOL finished) {
                [self.view layoutSubviews];
                [self.view setNeedsDisplay];
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
    if (self.correctAnswerSelected) {
        [self setupQuestionsWithAnimation];
        return;
    }
    
    if ([self.quizGenerator is:sender.titleLabel.text correctforQuestion: self.questionLabel.text]) {
        [sender buttonLooksRight];
        self.correctAnswerSelected = YES;
    } else {
        [sender buttonLooksWrong];
    }
}

@end
