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


@end
