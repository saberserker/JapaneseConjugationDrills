//
//  FPNHangulQuizGenerator.h
//  mudamuda
//
//  Created by Henry Tsang on 4/28/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNMultipleChoiceQuizGenerator.h"

@interface FPNHangulQuizGenerator : NSObject <FPNMultipleChoiceQuizGenerator>
//@property (nonatomic, assign) KanaType practiceMode;

//+(FPNAllRomanjiForKana*)quizWithType:(KanaType)kType;

-(void)generateMultipleChoice:(void (^)(NSString* question, NSArray* wrongAnswers))callback;
-(BOOL)is:(NSString*)answer correctforQuestion:(NSString*) question;

@end
