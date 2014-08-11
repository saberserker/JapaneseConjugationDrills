//
//  FPNQuizSelectorTableVC.m
//  mudamuda
//
//  Created by Henry Tsang on 4/25/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNQuizSelectorTableVC.h"
#import "FPNMultipleChoiceQuizGenerator.h"
#import "FPNMultipleChoiceVC.h"
#import "FPNAllRomanjiForKana.h"
#import "FPNHangulQuizGenerator.h"
#import "UIViewController+Colors.h"
#import "FPNConjugateJapaneseQuizGenerator.h"
#import "FPNConjugationMultipleChoiceVC.h"

@interface FPNQuizSelectorTableVC ()
@property (nonatomic,strong) NSArray * cellNames;
@property (nonatomic,strong) NSArray * quizGenerator;

@property (nonatomic,strong) NSArray * sectionNames;
@property (nonatomic,strong) NSArray * vcNames;
@property (nonatomic,strong) NSArray * vcs;


@end

@implementation FPNQuizSelectorTableVC

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSArray* kana = @[@"Hiragana Basic", @"Hiragana Marked", @"Hiragana Doubled", @"Hiragana Doubled and Marked", @"Hiragana All", @"Katakana Basic", @"Katakana Marked", @"Katakana Doubled", @"Katakana Doubled and Marked", @"Katakana All", @"Everything Kana"];
    NSArray* conju = @[                        @"て-form",
                                               @"た-form",
                                               @"ない-form",
                                               @"ます-stem",
                                               @"える-form",
                                               @"Causative form",
                                               @"Passive form",
                                               @"えば-form",
                                               @"Imperative form",
                                               @"Volitional form"];
    NSArray* bonus = @[@"Hangul Jamo", @"About"];
    
    NSArray* kanaVCs = @[[FPNAllRomanjiForKana quizWithType: kHiraganaBasic],
                         [FPNAllRomanjiForKana quizWithType: kHiraganaMarked],
                         [FPNAllRomanjiForKana quizWithType: kHiraganaDouble],
                         [FPNAllRomanjiForKana quizWithType: kHiraganaMarkedDouble],
                         [FPNAllRomanjiForKana quizWithType: kHiraganaAll],
                         [FPNAllRomanjiForKana quizWithType: kKatakanaBasic],
                         [FPNAllRomanjiForKana quizWithType: kKatakanaMarked],
                         [FPNAllRomanjiForKana quizWithType: kKatakanaDouble],
                         [FPNAllRomanjiForKana quizWithType: kKatakanaMarkedDouble],
                         [FPNAllRomanjiForKana quizWithType: kKatakanaAll],
                         [FPNAllRomanjiForKana quizWithType: kKanaAll]];
    
    NSArray* conjuVCs = @[[FPNConjugateJapaneseQuizGenerator newWithConjugation:@"TEFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"TAFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"NAIFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"IFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"ERUFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"CAUSATIVEFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"PASSIVEFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"EBAFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"IMPERATIVEFORM"],
                          [FPNConjugateJapaneseQuizGenerator newWithConjugation:@"VOLITIONALFORM"]];
    
    NSArray* otherVCs = @[[FPNHangulQuizGenerator new], [FPNHangulQuizGenerator new]];
    self.vcs = @[kanaVCs,conjuVCs,otherVCs];


    self.sectionNames = @[@"Hiragana/Katakana",@"Conjugation",@"Other"];
    self.vcNames = @[kana,conju,bonus];


    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void) viewWillAppear:(BOOL)animated {
    [self setThemeColor:0];
    self.view.backgroundColor = [UIColor colorWithHue:self.themeColor saturation:0.5 brightness:0.8 alpha:1];
    [self.tableView reloadData];
}

- (void) viewWillDisappear:(BOOL)animated {
//    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionNames.count;
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.sectionNames[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return MIN(((NSArray*)self.vcNames[section]).count, ((NSArray*)self.vcs[section]).count);
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quizSelect" forIndexPath:indexPath];
    cell.textLabel.text = ((NSArray*)self.vcNames[indexPath.section])[indexPath.row];
    cell.textLabel.textColor = [UIColor whiteColor];
    
    CGFloat min = 0.8;
    CGFloat ds  = 0.4 / [self tableView:tableView numberOfRowsInSection:0];
    CGFloat final = min - ds * indexPath.row;
    cell.backgroundColor = [UIColor colorWithHue:self.themeColor saturation:(final )  brightness:final / 2 alpha:1];
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    id gen = ((NSArray*)self.vcs[indexPath.section])[indexPath.row];
    if ([gen isKindOfClass:[FPNConjugateJapaneseQuizGenerator class]]) {
        [self performSegueWithIdentifier:@"toConjugationMultipleChoice" sender:indexPath];
        return;
    }
    if ([gen conformsToProtocol:@protocol(FPNMultipleChoiceQuizGenerator)]) {
        [self performSegueWithIdentifier:@"toMultipleChoice" sender:indexPath];
        return;
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath* indexPath = sender;
    UIViewController* nextVC = segue.destinationViewController;
    if ([segue.identifier isEqualToString:@"toMultipleChoice"]){
        FPNMultipleChoiceVC* multi = segue.destinationViewController;
        multi.quizGenerator = ((NSArray*)self.vcs    [indexPath.section])[indexPath.row];
    }
    if ([segue.identifier isEqualToString:@"toConjugationMultipleChoice"]){
        FPNConjugationMultipleChoiceVC* multi = segue.destinationViewController;
        multi.conjugationGenerator = ((NSArray*)self.vcs    [indexPath.section])[indexPath.row];
    }
    nextVC.navigationItem.title = ((NSArray*)self.vcNames[indexPath.section])[indexPath.row];
    [nextVC setThemeColor: self.themeColor];
}


@end
