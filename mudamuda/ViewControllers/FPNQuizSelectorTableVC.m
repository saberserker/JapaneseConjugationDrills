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

@interface FPNQuizSelectorTableVC ()
@property (nonatomic,strong) NSArray * cellNames;
@property (nonatomic,strong) NSArray * quizGenerator;
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
    self.cellNames = @[ @"Hiragana Basic", @"Hiragana Marked", @"Hiragana Doubled", @"Hiragana Basic and Marked", @"Hiragana All", @"Katakana Basic", @"Katakana Marked", @"Katakana Doubled", @"Katakana Basic and Marked", @"Katakana All", @"Everything Kana"];
    self.quizGenerator = @[[FPNAllRomanjiForKana quizWithType: kHiraganaBasic],
                           [FPNAllRomanjiForKana quizWithType: kHiraganaMarked],
                           [FPNAllRomanjiForKana quizWithType: kHiraganaDouble],
                           [FPNAllRomanjiForKana quizWithType: kHiraganaMarkedDouble],[FPNAllRomanjiForKana quizWithType: kHiraganaAll],[FPNAllRomanjiForKana quizWithType: kKatakanaBasic],[FPNAllRomanjiForKana quizWithType: kKatakanaMarked],[FPNAllRomanjiForKana quizWithType: kKatakanaDouble],[FPNAllRomanjiForKana quizWithType: kKatakanaMarkedDouble],[FPNAllRomanjiForKana quizWithType: kKatakanaAll],[FPNAllRomanjiForKana quizWithType: kKanaAll]];

    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = YES;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.cellNames.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"quizSelect" forIndexPath:indexPath];
    cell.textLabel.text = self.cellNames[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView  didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self performSegueWithIdentifier:@"toMultipleChoice" sender:self.quizGenerator[indexPath.row]];
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

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    id<FPNMultipleChoiceQuizGenerator> gen = sender;
    FPNMultipleChoiceVC* multi = segue.destinationViewController;
    multi.quizGenerator = gen;
}


@end
