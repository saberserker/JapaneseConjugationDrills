//
//  FPNAboutVC.m
//  mudamuda
//
//  Created by Henry Tsang on 8/29/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNAboutVC.h"
#import "UIViewController+Colors.h"
#import "FPNViewBorderColorizer.h"

@interface FPNAboutVC ()
@property (weak, nonatomic) IBOutlet UISlider *colorSlider;

@end

@implementation FPNAboutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [self setupThemeColors];
}

- (void) setupThemeColors {
    CGFloat themeHue = self.themeColor;
    FPNViewBorderColorizer* background = (FPNViewBorderColorizer*)self.view;
    [background colorWithHue:themeHue];
    self.colorSlider.tintColor = [UIColor colorWithHue:themeHue saturation:0.9 brightness:0.5 alpha:1];
    self.colorSlider.value = self.themeColor;
}

- (IBAction)sliderChanged:(UISlider *)sender {
    self.themeColor = sender.value;
    [self setupThemeColors];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
