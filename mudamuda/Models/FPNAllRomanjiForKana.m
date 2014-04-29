//
//  FPNAllRomanjiForKana.m
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNAllRomanjiForKana.h"

@interface FPNAllRomanjiForKana ()
@property (nonatomic,strong) NSString* correctAnswer;
@end


@implementation FPNAllRomanjiForKana
+(FPNAllRomanjiForKana*)quizWithType:(KanaType)kType {
    FPNAllRomanjiForKana* retval = [[FPNAllRomanjiForKana alloc] init];
    retval.practiceMode = kType;
    return retval;
}

-(void)generateMultipleChoice:(void (^)(NSString* question, NSArray* wrongAnswers))callback {
    //generate a pool of stuff to pull from
    NSDictionary* katakana = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"katakana" ofType:@"plist"]];
    NSDictionary* hiragana = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hiragana" ofType:@"plist"]];

    NSMutableDictionary* bag = [NSMutableDictionary new];
    
    if (self.practiceMode & kHiraganaBasic) [bag addEntriesFromDictionary:hiragana[@"basic"]];
    if (self.practiceMode & kHiraganaMarked) [bag addEntriesFromDictionary:hiragana[@"marked"]];
    if (self.practiceMode & kHiraganaDouble) [bag addEntriesFromDictionary:hiragana[@"double"]];
    if (self.practiceMode & kHiraganaMarkedDouble) [bag addEntriesFromDictionary:hiragana[@"marked+double"]];
    if (self.practiceMode & kKatakanaBasic) [bag addEntriesFromDictionary:katakana[@"basic"]];
    if (self.practiceMode & kKatakanaMarked) [bag addEntriesFromDictionary:katakana[@"marked"]];
    if (self.practiceMode & kKatakanaDouble) [bag addEntriesFromDictionary:katakana[@"double"]];
    if (self.practiceMode & kKatakanaMarkedDouble) [bag addEntriesFromDictionary:katakana[@"marked+double"]];

    NSMutableArray* randomKeys = [[NSMutableArray alloc] initWithArray:[bag allKeys]];
    
    for (int i = 0; i < randomKeys.count; i++) {
        int r = arc4random_uniform(randomKeys.count);
        [randomKeys exchangeObjectAtIndex:i withObjectAtIndex:r];
    }
    bool keysAreAnswers = arc4random() % 2 == 0;
    
    if (keysAreAnswers) {
        callback(bag[randomKeys[0]],randomKeys);
        self.correctAnswer = randomKeys[0];
    } else {
        NSMutableArray* possibleAnswers = [NSMutableArray new];
        for (id key in randomKeys) {
            if (![possibleAnswers containsObject:bag[key]]) {
                [possibleAnswers addObject:bag[key]];
            }
        }
        callback(randomKeys[0],possibleAnswers);
        self.correctAnswer = bag[randomKeys[0]];
    }
}

-(BOOL)is:(NSString*)answer correctforQuestion:(NSString*) question {
    return [answer isEqualToString:self.correctAnswer];
}
@end
