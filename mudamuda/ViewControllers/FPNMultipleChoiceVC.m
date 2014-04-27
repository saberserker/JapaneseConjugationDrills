//
//  FPNMultipleChoiceVC.m
//  mudamuda
//
//  Created by Henry Tsang on 4/22/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNMultipleChoiceVC.h"
#import "FPNAllRomanjiForKana.h"

@interface FPNMultipleChoiceVC ()
@property (weak, nonatomic) IBOutlet UITextView *questionView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *answerButton;
@end

@implementation FPNMultipleChoiceVC


- (void)viewDidLoad
{
    [super viewDidLoad];
    for (UIButton* b in self.answerButton) {
        [b addTarget:self action:@selector(answerPushed:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self setupQuestions];
}

static BOOL correctAnswerSelected;
- (void) setupQuestions {
    //set buttons to original state
    for (UIButton* b in self.answerButton) {
        b.backgroundColor = [UIColor whiteColor];
    }
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

- (IBAction)answerPushed: (UIButton*) sender {
    if (correctAnswerSelected) {
        [self setupQuestionsWithAnimation];
        return;
    }
    
    if ([self.quizGenerator is:sender.titleLabel.text correctforQuestion: self.questionView.text]) {
        sender.backgroundColor = [UIColor greenColor];
        correctAnswerSelected = YES;
    } else {
        sender.backgroundColor = [UIColor redColor];
    }
}

@end
