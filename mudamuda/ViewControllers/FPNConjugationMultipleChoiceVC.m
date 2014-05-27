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

- (void) setupQuestionsWithAnimation {
    [super setupQuestionsWithAnimation];
    
    NSArray* questionViews = @[self.wordLabel,self.furiganaLabel,self.wordTypeLabel,self.definitionLabel];
    NSRange viewRange = [self rangeBasedOnCollectionOfViews:questionViews];
    
    
    for (UIView* v in questionViews) {
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

@end
