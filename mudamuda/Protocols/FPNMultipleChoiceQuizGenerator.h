//
//  FPNMultipleChoiceQuizGenerator.h
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FPNMultipleChoiceQuizGenerator <NSObject>
@required
-(void)generateMultipleChoice:(void (^)(NSString* question, NSString* correctAnswer, NSArray* wrongAnswers))callback;
@end
