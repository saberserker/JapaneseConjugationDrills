//
//  FPNAllRomanjiForKana.m
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNAllRomanjiForKana.h"

@implementation FPNAllRomanjiForKana
+(FPNAllRomanjiForKana*)quizWithType:(KanaType)kType {
    FPNAllRomanjiForKana* retval = [[FPNAllRomanjiForKana alloc] init];
    retval.practiceMode = kType;
    return retval;
}

-(void)generateMultipleChoice:(void (^)(NSString* question, NSString* correctAnswer, NSArray* wrongAnswers))callback {
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


    NSMutableArray* randomSelection = [[NSMutableArray alloc] initWithArray:[bag allKeys]];
    
    for (int i = 0; i < 7; i++) {
        int r = arc4random_uniform(randomSelection.count);
        [randomSelection exchangeObjectAtIndex:i withObjectAtIndex:r];
    }
    NSString* cK = randomSelection[0];
    NSString* cV = bag[randomSelection[0]];
    
    bool keysAreAnswers = arc4random() % 2 == 0;
    
    if (keysAreAnswers) {
        callback(cV,cK,[randomSelection subarrayWithRange:NSMakeRange(1, 5)]);
    } else {
        NSMutableArray* incorrect = [NSMutableArray new];
        for (id key in [randomSelection subarrayWithRange:NSMakeRange(1,5)]) {
            [incorrect addObject:bag[key]];
        }
        callback(cK,cV,incorrect);
    }
}
@end
