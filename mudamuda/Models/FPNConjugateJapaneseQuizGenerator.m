//
//  FPNConjugateJapaneseQuizGenerator.m
//  mudamuda
//
//  Created by Henry Tsang on 5/5/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNConjugateJapaneseQuizGenerator.h"

@interface FPNConjugateJapaneseQuizGenerator ()
@property (nonatomic,strong) NSString* correctAnswer;
@property (nonatomic,strong) NSString* wordCategory;
@property (nonatomic,strong) NSString* conjugationCategory;
@end


@implementation FPNConjugateJapaneseQuizGenerator

-(NSArray*)validWordCategoriesForConjugationRules:(NSString*) someForm {
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
    if ([[rules allKeys] containsObject:someForm]) {
        return rules[someForm];
    }
    return nil;
}

-(void)generateMultipleChoice:(void (^)(NSString* question, NSArray* wrongAnswers))callback {
    //pick any conjugation category randomly
    self.conjugationCategory = @"TEFORM";
    
    NSArray* validVerbCats = [self validWordCategoriesForConjugationRules:self.conjugationCategory];
    NSDictionary* vocab = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"japanese_words" ofType:@"plist"]];
    
    //pick a word category, any category
    self.wordCategory = [validVerbCats objectAtIndex:arc4random_uniform(validVerbCats.count)];
    
    //pick a word, any word
    NSDictionary* wordlistdict = (NSDictionary*)vocab[self.wordCategory];
    NSString* word = [wordlistdict allKeys][arc4random_uniform(wordlistdict.count)];
    
    self.correctAnswer = [self conjugatePlainForm:word wordType:self.wordCategory conjugationType:self.conjugationCategory];
    NSArray* wrongAnswers = @[self.correctAnswer, @"so doge", @"four", @"hatsune miku", @"doge", @"dog"];
    
    //stuff that make the question presentable
    NSString* furigana = ((NSDictionary*)wordlistdict[word])[@"furigana"];
    NSString* displayableProblemString = [@[word, furigana, self.wordCategory] componentsJoinedByString:@"\n"];
    callback(displayableProblemString,wrongAnswers);
}

-(BOOL)is:(NSString*)answer correctforQuestion:(NSString*) question {
    return [answer isEqualToString:self.correctAnswer];
}

-(NSString*)conjugatePlainForm:(NSString*)plainForm wordType:(NSString*) wordType conjugationType:(NSString*)conjugationType {
    NSMutableString* retval = [plainForm mutableCopy];
    NSDictionary* conjugationRules = [FPNConjugateJapaneseQuizGenerator conjugationRules];
    NSDictionary* specificRules = (NSDictionary*)((NSDictionary*)conjugationRules[conjugationType])[wordType];
    for (NSString* pattern in [specificRules allKeys]) {
        NSError* error = nil;
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:&error];
        [regex replaceMatchesInString:retval options:0 range:NSMakeRange(0, retval.length) withTemplate:(NSString*)specificRules[pattern]];
        if (error) {
            NSLog(@"There was an error! plain form: %@ resultForm:%@",plainForm,retval);
            NSLog(@"wordtype:%@ conjugationType:%@",wordType,conjugationType);
        }
    }
    return retval;
}

+(NSDictionary*)conjugationRules {
    NSDictionary* retval =
    @{
      @"TEFORM":
        @{@"V5":
          @{@"う$":@"って",
            @"く$":@"いて",
            @"ぐ$":@"いで",
            @"す$":@"して",
            @"つ$":@"って",
            @"ぬ$":@"んで",
            @"ぶ$":@"んで",
            @"む$":@"んで",
            @"る$":@"って"},
          @"V1":
            @{@"いる$":@"いて",
              @"える$":@"えて"},
          @"ADJI":
              @{@"い$":@"くて"},
          @"ADJNA":
              @{@"な{0,1}$":@"で"}
          },
      @"TAFORM":
          @{@"V5":
                @{@"う$":@"った",
                  @"く$":@"いた",
                  @"ぐ$":@"いだ",
                  @"す$":@"した",
                  @"つ$":@"った",
                  @"ぬ$":@"んだ",
                  @"ぶ$":@"んだ",
                  @"む$":@"んだ",
                  @"る$":@"った"},
            @"V1":
                @{@"いる$":@"いた",
                  @"える$":@"えた"},
            @"ADJI":
                @{@"い$":@"かった"},
            @"ADJNA":
                @{@"な{0,1}$":@"だった"}
            },
      @"NAIFORM":
          @{@"V5":
              @{@"う$":@"わない",
                @"く$":@"かない",
                @"ぐ$":@"がない",
                @"す$":@"さない",
                @"つ$":@"たない",
                @"ぬ$":@"なない",
                @"ぶ$":@"ばない",
                @"む$":@"まない",
                @"る$":@"らない"},
            @"V1":
                @{@"いる$":@"いない",
                  @"える$":@"えない"},
            @"ADJI":
                @{@"い$":@"くない"},
            @"ADJNA":
                @{@"な{0,1}$":@"じゃない"},
            }
      };
    return retval;
}

@end
