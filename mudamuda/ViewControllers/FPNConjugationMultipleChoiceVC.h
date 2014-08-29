//
//  FPNConjugationMultipleChoiceVC.h
//  mudamuda
//
//  Created by htsang on 5/26/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNMultipleChoiceVC.h"
#import "FPNConjugateJapaneseQuizGenerator.h"
#import "FPNConcealableQuestionLabel.h"

@interface FPNConjugationMultipleChoiceVC : FPNMultipleChoiceVC <UIGestureRecognizerDelegate>
@property (nonatomic,strong, setter = setConjugationGenerator:) FPNConjugateJapaneseQuizGenerator* conjugationGenerator;

@end
