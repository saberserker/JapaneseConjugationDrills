//
//  mudamudaTests.m
//  mudamudaTests
//
//  Created by Henry Tsang on 4/22/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FPNConjugateJapaneseQuizGenerator.h"

@interface mudamudaTests : XCTestCase

@end

@implementation mudamudaTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testForConjugationInequity {
    NSArray* withAdj = @[@"V1",@"V5",@"ADJNA",@"ADJI"];
    NSArray* noAdj = @[@"V1",@"V5"];
    NSDictionary* rules = @{@"TEFORM":withAdj,
                            @"TAFORM":withAdj,
                            @"NAIFORM":withAdj,
                            @"IFORM":noAdj,
                            @"ERUFORM":noAdj,
                            @"CAUSATIVEFORM":withAdj,
                            @"PASSIVEFORM":noAdj,
                            @"EBAFORM":withAdj,
                            @"IMPERATIVEFORM":noAdj,
                            @"VOLITIONALFORM":withAdj,};
    
    NSDictionary* vocab = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"japanese_words" ofType:@"plist"]];
    
    FPNConjugateJapaneseQuizGenerator* generator = [FPNConjugateJapaneseQuizGenerator new];
    for (NSString* conjugation in [rules allKeys]) {
        NSArray* validWordTypesForConjugation = rules[conjugation];
        for (NSString* wordTypeKey in validWordTypesForConjugation) {
            NSDictionary* wordsOfType = vocab[wordTypeKey];
            for (NSString* word in [wordsOfType allKeys]) {
                NSString* conjugatedWord = [generator conjugatePlainForm:word wordType:wordTypeKey conjugationType:conjugation];
                XCTAssert(![word isEqualToString:conjugatedWord], @"Unconjugated Word should not be equal to plain version!");
            }
        }
    }
    
}

- (void)testExample
{
    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}

@end
