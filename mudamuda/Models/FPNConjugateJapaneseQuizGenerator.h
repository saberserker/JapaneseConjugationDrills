//
//  FPNConjugateJapaneseQuizGenerator.h
//  mudamuda
//
//  Created by Henry Tsang on 5/5/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNMultipleChoiceQuizGenerator.h"

@interface FPNConjugateJapaneseQuizGenerator : NSObject <FPNMultipleChoiceQuizGenerator>
+ (FPNConjugateJapaneseQuizGenerator*) newWithConjugation: (NSString*) conjugation;
- (void)generateMultipleChoice:(void (^)(NSString* question, NSArray* wrongAnswers))callback;
- (BOOL)is:(NSString*)answer correctforQuestion:(NSString*) question;

@end
