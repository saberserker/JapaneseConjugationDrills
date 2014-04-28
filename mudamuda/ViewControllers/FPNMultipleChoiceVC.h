//
//  FPNMultipleChoiceVC.h
//  mudamuda
//
//  Created by Henry Tsang on 4/22/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FPNMultipleChoiceQuizGenerator.h"


@interface FPNMultipleChoiceVC : UIViewController
@property (strong, nonatomic) id<FPNMultipleChoiceQuizGenerator> quizGenerator;
@end
