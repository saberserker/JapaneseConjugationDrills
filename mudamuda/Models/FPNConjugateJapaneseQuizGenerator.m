//
//  FPNConjugateJapaneseQuizGenerator.m
//  mudamuda
//
//  Created by Henry Tsang on 5/5/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNConjugateJapaneseQuizGenerator.h"
#import "NSArray+Tools.h"

@interface FPNConjugateJapaneseQuizGenerator ()
@property (nonatomic,strong) NSString* correctAnswer;
@property (nonatomic,strong) NSString* wordCategory;
@property (nonatomic,strong) NSString* conjugationCategory;
@end


@implementation FPNConjugateJapaneseQuizGenerator

+ (FPNConjugateJapaneseQuizGenerator*) newWithConjugation: (NSString*) conjugation{
    FPNConjugateJapaneseQuizGenerator* retval = [FPNConjugateJapaneseQuizGenerator new];
    retval.conjugationCategory = conjugation;
    return retval;
}

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

- (void)generateConjugationMultipleChoice:(void (^)(NSString * verb, NSString * furigana, NSString * verbType, NSString * definition, NSArray * possibleAnswers))callback {
    //pick a conjugation category if it doesn't exist
    if (self.conjugationCategory == nil) {
        self.conjugationCategory = @"TEFORM";
    }
    
    NSArray* validVerbCats = [self validWordCategoriesForConjugationRules:self.conjugationCategory];
    NSDictionary* vocab = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"japanese_words" ofType:@"plist"]];
    
    //pick a word category, any category
    self.wordCategory = [validVerbCats objectAtIndex:arc4random_uniform(validVerbCats.count)];
    
    //pick a word, any word
    NSDictionary* wordlistdict = (NSDictionary*)vocab[self.wordCategory];
    NSString* word = [wordlistdict allKeys][arc4random_uniform(wordlistdict.count)];
    
    self.correctAnswer = [self conjugatePlainForm:word wordType:self.wordCategory conjugationType:self.conjugationCategory];
    //    NSArray* wrongAnswers = @[self.correctAnswer, @"so doge", @"four", @"hatsune miku", @"doge", @"dog"];
    NSArray* wrongAnswers = [self generateIncorrectAnswersThatDoNotMatch:self.correctAnswer conjugatePlainForm:word wordType:self.wordCategory conjugationType:self.conjugationCategory];
    
    //stuff that make the question presentable
    NSDictionary* adjKeyForDescription = @{@"V1":   @"Ichidan Verb",
                                           @"V5":    @"Godan Verb",
                                           @"ADJNA": @"な-Adjective",
                                           @"ADJI":  @"い-Adjective"};
    
    NSString* furigana = ((NSDictionary*)wordlistdict[word])[@"furigana"];
    NSString* englishMeaning = ((NSDictionary*)wordlistdict[word])[@"definition"];
    
    
    callback(word,furigana,adjKeyForDescription[self.wordCategory],englishMeaning,wrongAnswers);
}

//legacy method
-(void)generateMultipleChoice:(void (^)(NSString* question, NSArray* wrongAnswers))callback {
    [self generateConjugationMultipleChoice:^(NSString *verb, NSString *furigana, NSString *verbType, NSString *definition, NSArray *possibleAnswers) {
        NSString* displayableProblemString = [@[verb, furigana, verbType, definition]componentsJoinedByString:@"\n"];
        callback(displayableProblemString,possibleAnswers);
    }];
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

-(NSArray*)generateIncorrectAnswersThatDoNotMatch:(NSString*)correctAnswer conjugatePlainForm:(NSString*)plainForm wordType:(NSString*) wordType conjugationType:(NSString*)conjugationType{
    NSMutableArray* retval = [[NSMutableArray alloc] initWithArray:@[correctAnswer]];
    NSDictionary* conjugationRules = [FPNConjugateJapaneseQuizGenerator conjugationRules];
    NSDictionary* thisConjugationRule = conjugationRules[conjugationType];
    
    NSMutableDictionary* everyRule = [NSMutableDictionary new];
    for (NSString* wordTypeKey in [thisConjugationRule allKeys]) {
        [everyRule addEntriesFromDictionary:thisConjugationRule[wordTypeKey]];
    }
         
    for (NSString* pattern in [everyRule allKeys]) {
        NSError* error = nil;
        NSMutableString* candidateString = [plainForm mutableCopy];
        
        NSString* incorrectPattern = [FPNConjugateJapaneseQuizGenerator incorrectPatterns][wordType];
        NSRegularExpression* regex = [NSRegularExpression regularExpressionWithPattern:incorrectPattern options:NSRegularExpressionAnchorsMatchLines error:&error];
        NSTextCheckingResult * result = [regex firstMatchInString:plainForm options:0 range:NSMakeRange(0, plainForm.length)];
        
        if (result) {
            [candidateString replaceCharactersInRange:result.range withString:(NSString*)everyRule[pattern]];
        }
        
        if (![retval containsObject:candidateString]) {
            [retval addObject:[candidateString copy]];
        }
        if (retval.count >= 6) {
            break;
        }
    }
    return [retval copy];
}

+(NSDictionary*)incorrectPatterns {
    NSString * hiragana = @"ぁあぃいぅうぇえぉおかがきぎくぐけげこごさざしじすずせぜそぞただちぢっつづてでとどなにぬねのはばぱひびぴふぶぷへべぺほぼぽまみむめもゃやゅゆょよらりるれろゎわゐゑをんゔゕゖ";
    NSString * replaceOne = [NSString stringWithFormat:@"[%@]{0,1}$",hiragana];
//    NSString * replaceTwo = [NSString stringWithFormat:@"[%@]{0,2}$",hiragana];
    return
    @{@"V5": replaceOne,
      @"V1": replaceOne,
      @"ADJI": replaceOne,
      @"ADJNA": replaceOne
      };
}

+(NSDictionary*)conjugationRules {
    // i hiragana : [いきぎしじちぢにひびぴみ]
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
            @{@"る$":@"て"},
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
                @{@"る$":@"た"},
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
                @{@"る$":@"ない"},
            @"ADJI":
                @{@"い$":@"くない"},
            @"ADJNA":
                @{@"な{0,1}$":@"じゃない"}
            },
      @"IFORM": @{
              @"V5": @{
                      @"う$":@"い",
                      @"く$":@"き",
                      @"ぐ$":@"ぎ",
                      @"す$":@"し",
                      @"つ$":@"ち",
                      @"ぬ$":@"に",
                      @"ぶ$":@"び",
                      @"む$":@"み",
                      @"る$":@"り"
                      },
              @"V1": @{ @"る$":@""}},
      
      @"ERUFORM": @{
              @"V5": @{
                      @"う$":@"える",
                      @"く$":@"ける",
                      @"ぐ$":@"げる",
                      @"す$":@"せる",
                      @"つ$":@"てる",
                      @"ぬ$":@"ねる",
                      @"ぶ$":@"べる",
                      @"む$":@"める",
                      @"る$":@"れる"
                      },
              @"V1": @{ @"る$":@"られる" }},
      @"CAUSATIVEFORM": @{
              @"V5": @{
                      @"う$":@"わせる",
                      @"く$":@"かせる",
                      @"ぐ$":@"がせる",
                      @"す$":@"させる",
                      @"つ$":@"たせる",
                      @"ぬ$":@"なせる",
                      @"ぶ$":@"ばせる",
                      @"む$":@"ませる",
                      @"る$":@"らせる"
                      },
              @"V1": @{ @"る$":@"させる"},
              @"ADJI": @{ @"い$":@"くさせる" },
              @"ADJNA": @{ @"な{0,1}$":@"にさせる" }},
    @"PASSIVEFORM": @{
                      @"V5": @{
                              @"う$":@"われる",
                              @"く$":@"かれる",
                              @"ぐ$":@"がれる",
                              @"す$":@"される",
                              @"つ$":@"たれる",
                              @"ぬ$":@"なれる",
                              @"ぶ$":@"ばれる",
                              @"む$":@"まれる",
                              @"る$":@"られる"
                              }, 
                      @"V1": @{ @"る$":@"られる" }},
    @"EBAFORM": @{ 
                  @"V5": @{
                          @"う$":@"えば",
                          @"く$":@"けば",
                          @"ぐ$":@"げば",
                          @"す$":@"せば",
                          @"つ$":@"てば",
                          @"ぬ$":@"ねば",
                          @"ぶ$":@"べば",
                          @"む$":@"めば",
                          @"る$":@"れば"
                          }, 
                  @"V1": @{ @"る$":@"れば"},
                  @"ADJI": @{ @"い$":@"ければ"},
                  @"ADJNA": @{ @"な{0,1}$":@"であれば" }
                  },
    @"IMPERATIVEFORM": @{
                         @"V5": @{
                                 @"う$":@"え",
                                 @"く$":@"け",
                                 @"ぐ$":@"げ",
                                 @"す$":@"せ",
                                 @"つ$":@"て",
                                 @"ぬ$":@"ね",
                                 @"ぶ$":@"べ",
                                 @"む$":@"め",
                                 @"る$":@"れ"},
                         @"V1": @{ @"る$":@"ろ"}},
    @"VOLITIONALFORM": @{
                         @"V5": @{
                                 @"う$":@"おう",
                                 @"く$":@"こう",
                                 @"ぐ$":@"ごう",
                                 @"す$":@"そう",
                                 @"つ$":@"とう",
                                 @"ぬ$":@"のう",
                                 @"ぶ$":@"ぼう",
                                 @"む$":@"もう",
                                 @"る$":@"ろう"},
                         @"V1": @{ @"る$":@"よう"}, 
                         @"ADJI": @{ @"い$":@"かろう"}, 
                         @"ADJNA": @{ @"な{0,1}$":@"だろう"}}
      };
    return retval;
}

@end
