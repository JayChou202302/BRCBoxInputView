//
//  AppDelegate.m
//  BRCBoxInputView_OC
//
//  Created by sunzhixiong on 2024/8/5.
//

#import "AppDelegate.h"
#import "BRCRootTabBarViewController.h"
#import <FLEX/FLEX.h>


@interface AppDelegate ()

@end

@implementation AppDelegate

- (UIViewController *)rootController {
    return [BRCRootTabBarViewController new];
}

@end
