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
    CGFloat themeHue = drand48();
    self.questionView.backgroundColor = [UIColor colorWithHue:themeHue saturation:0.4 brightness:0.8 alpha:1];
    self.questionView.layer.borderColor = [UIColor colorWithHue:themeHue saturation:0.8 brightness:0.7 alpha:1].CGColor;
    for (FPNQuizAnswerButton* button in self.answerButton) {
        [button resetButtonWithHue:themeHue];
    }
//    self.view.backgroundColor = [UIColor colorWithHue:themeHue saturation:0.6 brightness:0.5 alpha:1];
    
    FPNViewBorderColorizer* background = (FPNViewBorderColorizer*)self.view;
    [background colorWithHue:themeHue];
}

static BOOL correctAnswerSelected;
- (void) setupQuestions {
    //set buttons to original state
//    for (UIButton* b in self.answerButton) {
////        b.backgroundColor = [UIColor whiteColor];
//    }
    correctAnswerSelected = false;
    
    NSMutableArray* randomButtons = [[NSMutableArray alloc] initWithArray:self.answerButton];
    for (int i = 0; i < randomButtons.count; i++) {
        [randomButtons exchangeObjectAtIndex:i withObjectAtIndex:arc4random_uniform(randomButtons.count)];
    }
    
    [self.quizGenerator generateMultipleChoice:^(NSString *question, NSArray *possibleAnswers) {
        self.questionView.text = question;
        [self.questionView setFont:[UIFont boldSystemFontOfSize:120]];
        [self.questionView setTextAlignment:NSTextAlignmentCenter];

        for (int i = 0; i < MIN(possibleAnswers.count, randomButtons.count); i++) {
           [((UIButton*)randomButtons[i]) setTitle:((NSString*)possibleAnswers[i]) forState:UIControlStateNormal];
        }
    }];
}

- (void) setupQuestionsWithAnimation {
    CATransform3D flattened3d = CATransform3DIdentity;
    flattened3d.m22 = 0.001;
    flattened3d.m24 = -0.000005;
    [UIView animateWithDuration:0.4 animations:^{
        for (UIView* sv in self.view.subviews) {
            sv.layer.transform = flattened3d;
        }
        [self setupThemeColors];
    } completion:^(BOOL finished) {
        [self setupQuestions];
        CATransform3D flattenedover3d = flattened3d;
        flattenedover3d.m24 = 0.000005;
        for (UIView* sv in self.view.subviews) {
            sv.layer.transform = flattenedover3d;
            [UIView animateWithDuration:0.4 animations:^{
                sv.layer.transform = CATransform3DIdentity;
            }];
        }
    }];
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
