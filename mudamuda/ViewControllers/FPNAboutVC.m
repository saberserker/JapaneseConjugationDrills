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
@property (weak, nonatomic) IBOutlet UITextView *emailField;

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
    [super viewWillAppear:animated];
    self.colorSlider.value = self.themeColor;
    [self setupThemeColors];
}

- (void) setupThemeColors {
    CGFloat themeHue = self.themeColor;
    [self setupThemeColorWithHue:themeHue];
}

- (void) setupThemeColorWithHue:(CGFloat) themeHue {
    FPNViewBorderColorizer* background = (FPNViewBorderColorizer*)self.view;
    [background colorWithHue:themeHue];
    self.colorSlider.tintColor = [UIColor colorWithHue:themeHue saturation:1 brightness:1 alpha:1];
    self.colorSlider.minimumTrackTintColor = [UIColor colorWithHue:themeHue saturation:0.3 brightness:1 alpha:1];
    self.emailField.tintColor = [UIColor colorWithHue:themeHue saturation:0.5 brightness:1 alpha:1];
}

- (IBAction)sliderChanged:(UISlider *)sender {
    CGFloat sv = sender.value;
    self.themeColor = sv;
    [self setupThemeColorWithHue:sv];
}

- (IBAction)colorChangeDidEnd:(UISlider *)sender {
    CGFloat sv = sender.value;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ThemeColorDidChange" object:nil];
}

@end
