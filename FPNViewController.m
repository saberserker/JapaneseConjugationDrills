//
//  FPNViewController.m
//  mudamuda
//
//  Created by htsang on 6/26/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNViewController.h"

@interface FPNViewController ()

@end

@implementation FPNViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void) histogramWordsInArray:(NSArray*)array {
    //we expect the array to have just NSStrings
    NSMutableDictionary* results = [NSMutableDictionary new];
    for(NSString* word in array) {
        NSString* captitalizedWord = [word lowercaseString];
        if (results[captitalizedWord] == nil) {
            [results setObject:@1 forKey:captitalizedWord] ;
        } else {
            NSNumber* number = [results objectForKey:captitalizedWord];
            number = [NSNumber numberWithDouble:[number integerValue] + 1];
            [results setObject:@1 forKey:captitalizedWord] ;
        }
    }
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
