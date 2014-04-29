//
//  FPNHangulQuizGenerator.m
//  mudamuda
//
//  Created by Henry Tsang on 4/28/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNHangulQuizGenerator.h"

@interface FPNHangulQuizGenerator ()
@property (nonatomic,strong) NSString* correctAnswer;
@end

@implementation FPNHangulQuizGenerator
-(void)generateMultipleChoice:(void (^)(NSString* question, NSArray* wrongAnswers))callback {
    //generate a pool of stuff to pull from
    NSDictionary* hangul = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"hangul" ofType:@"plist"]];
    
    NSMutableDictionary* bag = [NSMutableDictionary new];
    [bag addEntriesFromDictionary:hangul[@"consonant"]];
    [bag addEntriesFromDictionary:hangul[@"vowels"]];

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
