//
//  FPNAllRomanjiForKana.h
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FPNMultipleChoiceQuizGenerator.h"

typedef enum {
    kHiraganaBasic          = 0x01,
    kHiraganaMarked         = 0x02,
    kHiraganaDouble         = 0x04,
    kHiraganaMarkedDouble   = 0x08,
    kHiraganaAll            = 0x0F,
    kKatakanaBasic          = 0x10,
    kKatakanaMarked         = 0x20,
    kKatakanaDouble         = 0x40,
    kKatakanaMarkedDouble   = 0x80,
    kKatakanaAll            = 0xF0,
    kKanaAll                = 0xFF
} KanaType;

@interface FPNAllRomanjiForKana : NSObject <FPNMultipleChoiceQuizGenerator>
@property (nonatomic, assign) KanaType practiceMode;

+(FPNAllRomanjiForKana*)quizWithType:(KanaType)kType;

-(void)generateMultipleChoice:(void (^)(NSString* question, NSString* correctAnswer, NSArray* wrongAnswers))callback;

@end

