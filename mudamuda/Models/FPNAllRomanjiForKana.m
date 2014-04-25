//
//  FPNAllRomanjiForKana.m
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNAllRomanjiForKana.h"

@implementation FPNAllRomanjiForKana
-(void)generateMultipleChoice:(void (^)(NSString* question, NSString* correctAnswer, NSArray* wrongAnswers))callback {
    //generate a pool of stuff to pull from
    NSString *path = [[NSBundle mainBundle] pathForResource:@"katakana" ofType:@"plist"];
    NSDictionary* katakana = [NSDictionary dictionaryWithContentsOfFile:path];
    NSMutableDictionary* flatkatakana = [NSMutableDictionary new];
    for (NSDictionary* key in [katakana allValues]) {
        [flatkatakana addEntriesFromDictionary:key];
    }
    
    NSMutableArray* randomSelection = [[NSMutableArray alloc] initWithArray:[flatkatakana allKeys]];
    
    for (int i = 0; i < 7; i++) {
        int r = arc4random_uniform(randomSelection.count);
        [randomSelection exchangeObjectAtIndex:i withObjectAtIndex:r];
    }
    NSString* cK = randomSelection[0];
    NSString* cV = flatkatakana[randomSelection[0]];
    
    bool keysAreAnswers = arc4random() % 2 == 0;
    
    if (keysAreAnswers) {
        callback(cV,cK,[randomSelection subarrayWithRange:NSMakeRange(1, 5)]);
    } else {
        NSMutableArray* incorrect = [NSMutableArray new];
        for (id key in [randomSelection subarrayWithRange:NSMakeRange(1,5)]) {
            [incorrect addObject:flatkatakana[key]];
        }
        callback(cK,cV,incorrect);
    }
}
@end
