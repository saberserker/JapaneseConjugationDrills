//
//  FPNConjugationMultipleChoiceVC.m
//  mudamuda
//
//  Created by htsang on 5/26/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNConjugationMultipleChoiceVC.h"

@interface FPNConjugationMultipleChoiceVC ()
@property (strong, nonatomic) IBOutlet UILabel *wordLabel;
@property (strong, nonatomic) IBOutlet UILabel *furiganaLabel;
@property (strong, nonatomic) IBOutlet UILabel *wordTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *definitionLabel;
@end

@implementation FPNConjugationMultipleChoiceVC

- (void)setConjugationGenerator:(FPNConjugateJapaneseQuizGenerator *)conjugationGenerator {
    self.quizGenerator = conjugationGenerator;
    _conjugationGenerator = conjugationGenerator;
}

- (void) setupQuestions {
    self.correctAnswerSelected = false;
    
    [self.conjugationGenerator generateConjugationMultipleChoice:^(NSString *word, NSString *furigana, NSString *wordType, NSString *definition, NSArray *possibleAnswers) {
        self.wordLabel.text = word;
        self.furiganaLabel.text = furigana;
        self.wordTypeLabel.text = wordType;
        self.definitionLabel.text = definition;
        [self assignToButtonsPossibleAnswers:possibleAnswers];
    }];
}

- (NSArray*) questionViews {
    return @[self.wordLabel,self.furiganaLabel,self.wordTypeLabel,self.definitionLabel];
}

- (void) setupQuestionsWithAnimation {
    [super setupQuestionsWithAnimation];
    
    NSRange viewRange = [self rangeBasedOnCollectionOfViews:[self questionViews]];
    
    
    for (UIView* v in [self questionViews]) {
        CGFloat animTime = 0.05 + 0.35 * [self stepBasedOnRange:viewRange forView:v];
        [UIView animateWithDuration:animTime animations:^{
            v.alpha = 0.0;
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:animTime delay:0.41 - animTime options:0 animations:^{
                v.alpha = 1.0;
            } completion:nil];
        }];
        
    }
}
- (IBAction)labelTapped:(UITapGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateEnded) {
        for (UILabel* l in [self questionViews]) {
            CGPoint tp = [sender locationOfTouch:0 inView:l.superview];
            if (CGRectContainsPoint(l.frame, tp)) {
                [self setLabelState:l];
                [self.view layoutIfNeeded];
                break;
            }
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return YES;
}

- (void) setLabelState: (UILabel*) label {
    if ([label isKindOfClass:[FPNConcealableQuestionLabel class]]) {
        [((FPNConcealableQuestionLabel*)label) toggleConcealed];
    }
}

@end
