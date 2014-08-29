//
//  FPNIPadSplitViewControllerDelegate.m
//  mudamuda
//
//  Created by Henry Tsang on 8/29/14.
//  Copyright (c) 2014 FreezedPeanuts. All rights reserved.
//

#import "FPNIPadSplitViewControllerDelegate.h"

@implementation FPNIPadSplitViewControllerDelegate

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation {
    return NO;
}
@end
