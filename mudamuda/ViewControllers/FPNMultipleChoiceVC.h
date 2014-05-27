//
//  FPNMultipleChoiceVC.h
//  mudamuda
//
//  Created by Henry Tsang on 4/22/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPNMultipleChoiceQuizGenerator.h"
#import "FPNQuizAnswerButton.h"


@interface FPNMultipleChoiceVC : UIViewController
@property (strong, nonatomic) id<FPNMultipleChoiceQuizGenerator> quizGenerator;
@property (assign, nonatomic) BOOL correctAnswerSelected;
@property (strong, nonatomic) IBOutletCollection(FPNQuizAnswerButton) NSArray *answerButton;

//internal helper methods
- (void) assignToButtonsPossibleAnswers:(NSArray*)possibleAnswers;
- (void) setupQuestionsWithAnimation;

//very esoteric animation helpers.
- (NSRange) rangeBasedOnCollectionOfViews:(NSArray*) views;
- (CGFloat) stepBasedOnRange:(NSRange) range forView:(UIView*)v;
@end
